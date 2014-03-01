#import <XCTest/XCTest.h>
#import "ZBRouteManager.h"
#include <stdlib.h>

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
		for (ZBRoute *route in routes) {
			NSLog(@"%@", route.stringPresentation);
		}
	}
}




@end
