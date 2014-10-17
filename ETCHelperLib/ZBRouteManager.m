#import "ZBRouteManager.h"

NSString *const ZBRouteManagerErrorDomain = @"ZBRouteManagerErrorDomain";

@interface ZBRouteManager ()
{
	NSMutableSet *nodes;
	NSMutableDictionary *freewayNodesMap;
}

@end

@implementation ZBRouteManager

- (ZBNode *)findOrCreateNodeWithName:(NSString *)inName
{
	ZBNode *aNode = [self nodeWithName:inName];
	if (!aNode) {
		aNode = [[ZBNode alloc] initWithName:inName];
		[nodes addObject:aNode];
	}
	return aNode;
}

- (void)_buildModelWithURL:(NSURL *)inURL
{
	nodes = [[NSMutableSet alloc] init];
	freewayNodesMap = [[NSMutableDictionary alloc] init];

	NSString *text = [[NSString alloc] initWithContentsOfURL:inURL encoding:NSUTF8StringEncoding error:nil];
	if (!text) {
		return;
	}
	NSArray *lines = [text componentsSeparatedByString:@"\n"];
	for (NSString *line in lines) {
		if ([line hasPrefix:@"#"]) { // comment
			continue;
		}

		NSArray *components = [line componentsSeparatedByString:@","];
		if ([components count] != 4) {
			continue;
		}
		NSString *tag = components[0];
		NSString *fromName = components[1];
		NSString *toName = components[2];
		NSString *priceString = components[3];
		ZBNode *fromNode = [self findOrCreateNodeWithName:fromName];
		ZBNode *toNode = [self findOrCreateNodeWithName:toName];
		makeLinkBetweenNodes(fromNode, toNode, [priceString doubleValue], tag);

		NSMutableArray *freewayNodes = [freewayNodesMap objectForKey:tag];
		if (!freewayNodes) {
			freewayNodes = [NSMutableArray array];
			[freewayNodesMap setObject:freewayNodes forKey:tag];
		}
		if (![freewayNodes containsObject:fromNode]) {
			[freewayNodes addObject:fromNode];
		}
		if (![freewayNodes containsObject:toNode]) {
			[freewayNodes addObject:toNode];
		}
	}
}

- (instancetype)initWithRoutingDataFileURL:(NSURL *)inURL
{
	self = [super init];
	if (self) {
		[self _buildModelWithURL:inURL];
	}
	return self;
}

- (ZBNode *)nodeWithName:(NSString *)inName
{
	NSParameterAssert(inName != nil);
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name == %@", inName];
	NSSet *matchingNodes = [nodes filteredSetUsingPredicate:predicate];
	if ([matchingNodes count]) {
		NSAssert([matchingNodes count] == 1, @"there should be only one item");
		return [matchingNodes anyObject];
	}
	return nil;
}

- (NSArray *)nodesOnFreeway:(NSString *)inName
{
	NSParameterAssert(inName != nil);
	return freewayNodesMap[inName];
}

- (void)travelLinksForNode:(ZBNode *)node beginNode:(ZBNode *)beginNode destination:(ZBNode *)destinationNode routes:(NSMutableArray *)routes vistedLinks:(NSMutableArray *)visitedLinks vistedNoodes:(NSMutableArray *)visitedNodes
{
	for (ZBLink *link in node.links) {
		ZBNode *to = link.to;
		if (to == destinationNode) {
			NSMutableArray *copy = [NSMutableArray arrayWithArray:visitedLinks];
			[copy addObject:link];
			ZBRoute *route = [[ZBRoute alloc] initWithBeginNode:beginNode links:copy];
			[routes addObject:route];
			continue;
		}
		if ([visitedNodes containsObject:to]) {
			continue;
		}
		[visitedLinks addObject:link];
		[visitedNodes addObject:to];
		[self travelLinksForNode:to beginNode:beginNode destination:destinationNode routes:routes vistedLinks:visitedLinks vistedNoodes:visitedNodes];
		[visitedLinks removeLastObject];
		[visitedNodes removeLastObject];
	}
}

- (NSArray *)possibleRoutesFromNode:(ZBNode *)fromNode toNode:(ZBNode *)toNode error:(NSError **)outError
{
	NSParameterAssert([nodes containsObject:fromNode]);
	NSParameterAssert([nodes containsObject:toNode]);
	if (fromNode == toNode) {
		NSError *error = [NSError errorWithDomain:ZBRouteManagerErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"The begin and the end should be different nodes.", @"")}];
		*outError = error;
		return nil;
	}

	NSMutableArray *routes = [NSMutableArray array];
	NSMutableArray *visitedLinks = [NSMutableArray array];
	NSMutableArray *visitedNodes = [NSMutableArray array];
	[visitedNodes addObject:fromNode];
	[self travelLinksForNode:fromNode beginNode:fromNode destination:toNode routes:routes vistedLinks:visitedLinks vistedNoodes:visitedNodes];

	[routes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		ZBRoute *a = (ZBRoute *)obj1;
		ZBRoute *b = (ZBRoute *)obj2;
		return [@(a.totalPrice) compare:@(b.totalPrice)];
	}];

	return routes;
}

- (NSArray *)possibleRoutesFrom:(NSString *)fromNodeName to:(NSString *)toNodeName error:(NSError **)outError
{
	ZBNode *fromNode = [self nodeWithName:fromNodeName];
	ZBNode *toNode = [self nodeWithName:toNodeName];
	return [self possibleRoutesFromNode:fromNode toNode:toNode error:outError];
}

@synthesize nodes;

- (NSSet *)allNodeNames
{
	return [nodes valueForKeyPath:@"name"];
}
- (NSSet *)allFreewayNames
{
	return [NSSet setWithArray:[freewayNodesMap allKeys]];
}

@end
