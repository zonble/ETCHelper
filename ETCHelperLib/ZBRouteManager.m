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

- (NSArray *)possibleRoutesFromNode:(ZBNode *)fromNode toNode:(ZBNode *)toNode error:(NSError **)outError
{
	NSParameterAssert([nodes containsObject:fromNode]);
	NSParameterAssert([nodes containsObject:toNode]);
	if (fromNode == toNode) {
		NSError *error = [NSError errorWithDomain:ZBRouteManagerErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"The begin and the end should be different nodes.", @"")}];
		*outError = error;
		return nil;
	}

	NSInteger currentIndex = 0;
	NSMutableArray *routes = [NSMutableArray array];
	NSArray *initialLinks = fromNode.links;
	for (ZBLink *link in initialLinks) {
		[routes addObject:[NSMutableArray arrayWithObject:link]];
	}
	while (currentIndex < [routes count]) {
		NSMutableArray *currentRoute = routes[currentIndex];
		NSMutableSet *existingNodes = [NSMutableSet setWithArray:[currentRoute valueForKeyPath:@"to"]];
		[existingNodes addObject:fromNode];

		ZBNode *lastNode = [[currentRoute lastObject] to];
		while (lastNode) {
			if (lastNode == toNode) {
				break;
			}
			NSArray *links = [lastNode linksBesideTowardNodes:existingNodes];
			if (![links count]) {
				lastNode = nil;
			}
			else {
				if ([links count] > 1) {
					NSArray *otherLinks = [links subarrayWithRange:NSMakeRange(1, [links count] -1)];
					for (ZBLink *link in otherLinks) {
						NSMutableArray *copyRoute = [NSMutableArray arrayWithArray:currentRoute];
						[copyRoute addObject:link];
						[routes addObject:copyRoute];
					}
				}
				ZBLink *firstLink = links[0];
				[currentRoute addObject:firstLink];
				[existingNodes addObject:firstLink.to];
				lastNode = firstLink.to;
			}
		}
		currentIndex++;
	}

	NSMutableArray *successRoutes = [NSMutableArray array];
	[routes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSArray *links = (NSArray *)obj;
		ZBLink *link = [links lastObject];
		if (link.to == toNode) {
			ZBRoute *route = [[ZBRoute alloc] initWithBeginNode:fromNode links:links];
			[successRoutes addObject:route];
		}
	}];

	[successRoutes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		ZBRoute *a = (ZBRoute *)obj1;
		ZBRoute *b = (ZBRoute *)obj2;
		return [@(a.totalPrice) compare:@(b.totalPrice)];
	}];
	return successRoutes;
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
