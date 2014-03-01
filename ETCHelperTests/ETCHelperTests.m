#import <XCTest/XCTest.h>
#import "ZBRouteManager.h"
#include <stdlib.h>

@implementation NSArray (Reverse)

- (NSArray *)reversedArray
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
	NSEnumerator *enumerator = [self reverseObjectEnumerator];
	for (id element in enumerator) {
		[array addObject:element];
	}
	return array;
}

@end

@interface ETCHelperTests : XCTestCase
{
	ZBRouteManager *manager;
}
@end

#define NODE(x) [manager nodeWithName:x]

@implementation ETCHelperTests

- (void)setUp
{
    [super setUp];
	NSBundle *b = [NSBundle bundleForClass:[self class]];
	NSURL *fileURL = [b URLForResource:@"data" withExtension:@"txt"];
	manager = [[ZBRouteManager alloc] initWithRoutingDataFileURL:fileURL];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testAllNodes
{
	NSSet *allNodeNames = [manager allNodeNames];
	XCTAssertTrue([allNodeNames count] > 0, @"We must have names");
	for (id obj in allNodeNames) {
		XCTAssertTrue([obj isKindOfClass:[NSString class]], @"All names must be strings");
	}
	NSSet *nodes = [manager nodes];
	XCTAssertTrue([nodes count] > 0, @"We must have names");
	for (ZBNode *node in nodes) {
		XCTAssertTrue([node isKindOfClass:[ZBNode class]], @"Must be a node");
		NSArray *links = node.links;
		XCTAssertTrue([links count] > 0, @"Must have a link.");
	}
}

- (void)testRoutesBetweenArbitraryNames
{
	for (NSInteger i = 0; i < 10; i++) {
		NSArray *nodes = [[manager allNodeNames] allObjects];
		NSString *from = [nodes objectAtIndex:arc4random() % [nodes count]];
		NSString *to = nil;
		while (to == nil) {
			NSString *aNode = [nodes objectAtIndex:arc4random() % [nodes count]];
			if (aNode != from) {
				to = aNode;
				break;
			}
		}
		NSArray *routes = [manager possibleRoutesFrom:from to:to error:nil];
		XCTAssertTrue([routes count] > 0, @"Must have at least a route");
	}
}

- (void)testRoutesBetweenArbitraryNodes
{
	for (NSInteger i = 0; i < 10; i++) {
		NSArray *nodes = [[manager nodes] allObjects];
		ZBNode *from = [nodes objectAtIndex:arc4random() % [nodes count]];
		ZBNode *to = nil;
		while (to == nil) {
			ZBNode *aNode = [nodes objectAtIndex:arc4random() % [nodes count]];
			if (aNode != from) {
				to = aNode;
				break;
			}
		}
		NSArray *routes = [manager possibleRoutesFromNode:from toNode:to error:nil];
		XCTAssertTrue([routes count] > 0, @"Must have at least a route");
	}
}

- (void)testFreeways
{
	NSArray *freewayNames = [[manager allFreewayNames] allObjects];
	for (NSString *name in freewayNames) {
		NSArray *nodes = [manager nodesOnFreeway:name];
		ZBNode *begin = [nodes firstObject];
		ZBNode *end = [nodes lastObject];
		NSArray *routes = [manager possibleRoutesFromNode:begin toNode:end error:nil];
		BOOL routeOnTheFreewayFound = NO;
		for (ZBRoute *route in routes) {
			NSArray *nodesOnRoute = [[NSArray arrayWithObject:begin] arrayByAddingObjectsFromArray:[route.links valueForKeyPath:@"to"]];
			if ([nodes count] != [nodesOnRoute count]) {
				continue;
			}
			NSMutableArray *copy = [NSMutableArray arrayWithArray:nodesOnRoute];
			[copy removeObjectsInArray:nodes];
			if ([copy count] == 0) {
				routeOnTheFreewayFound = YES;
				break;
			}
		}
		XCTAssert(routeOnTheFreewayFound, @"There must be a route using all node on the same freeway");
	}
}

- (void)testFreewaysReversed
{
	NSArray *freewayNames = [[manager allFreewayNames] allObjects];
	for (NSString *name in freewayNames) {
		NSArray *nodes = [[manager nodesOnFreeway:name] reversedArray];
		ZBNode *begin = [nodes firstObject];
		ZBNode *end = [nodes lastObject];
		NSArray *routes = [manager possibleRoutesFromNode:begin toNode:end error:nil];
		BOOL routeOnTheFreewayFound = NO;
		for (ZBRoute *route in routes) {
			NSArray *nodesOnRoute = [[NSArray arrayWithObject:begin] arrayByAddingObjectsFromArray:[route.links valueForKeyPath:@"to"]];
			if ([nodes count] != [nodesOnRoute count]) {
				continue;
			}
			NSMutableArray *copy = [NSMutableArray arrayWithArray:nodesOnRoute];
			[copy removeObjectsInArray:nodes];
			if ([copy count] == 0) {
				routeOnTheFreewayFound = YES;
				break;
			}
		}
		XCTAssert(routeOnTheFreewayFound, @"There must be a route using all node on the same freeway");
	}
}

@end
