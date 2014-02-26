#import "ZBNode.h"
#import "ZBLink.h"

@interface ZBNode ()
{
	NSString *name;
	NSMutableArray *links;
}
@end

@implementation ZBNode

- (instancetype)initWithName:(NSString *)inName
{
	self = [super init];
	if (self) {
		name = inName;
		links = [[NSMutableArray alloc] init];
	}
	return self;
}

- (NSString *)description
{
	NSString *l = [[links valueForKeyPath:@"description"] componentsJoinedByString:@","];
	return [NSString stringWithFormat:@"<%@ %p name:%@ links:%@>", NSStringFromClass([self class]), self, name, l];
}

- (void)makeLinkTowardNode:(ZBNode *)inNode forPrice:(double)inPrice tag:(NSString *)inTag
{
	ZBLink *link = [[ZBLink alloc] initWithNode:inNode price:inPrice tag:inTag];
	[links addObject:link];
}

- (NSArray *)linksBesideTowardNodes:(NSSet *)inNodes
{
	NSMutableArray *newLinks = [NSMutableArray array];
	[links enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		ZBLink *aLink = (ZBLink *)obj;
		if (![inNodes containsObject:aLink.to]) {
			[newLinks addObject:aLink];
		}
	}];
	return newLinks;
}

@synthesize name;
@synthesize links;
@end


void makeLinkBetweenNodes(ZBNode *aNode, ZBNode *bNode, double price, NSString *tag)
{
	[aNode makeLinkTowardNode:bNode forPrice:price tag:tag];
	[bNode makeLinkTowardNode:aNode forPrice:price tag:tag];
}
