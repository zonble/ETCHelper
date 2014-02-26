#import <XCTest/XCTest.h>
#import "ZBRouteManager.h"


@interface EtagHelperTests : XCTestCase
{
	ZBRouteManager *manager;
}
@end

#define NODE(x) [manager nodeWithName:x]

@implementation EtagHelperTests

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

- (void)testName
{
	NSSet *allNodeNames = [manager allNodeNames];
	NSLog(@"allNodeNames:%@", [[allNodeNames allObjects] componentsJoinedByString:@","]);

	NSSet *allFreewayNames = [manager allFreewayNames];
	NSLog(@"allFreewayNames:%@", [[allFreewayNames allObjects] componentsJoinedByString:@","]);

	NSArray *nodes = [manager nodesOnFreeway:@"國 1 高架"];
	XCTAssertTrue([@"汐止系統,堤頂,下塔悠出口,環北,五股,泰山轉接道,機場系統,中壢,楊梅" isEqualToString:[[nodes valueForKeyPath:@"name"] componentsJoinedByString:@","]],  @"Nodes should match");
}

//- (void)testExample1
//{
//	NSArray *routes = [manager possibleRoutesFromNode:NODE(@"國姓") toNode:NODE(@"基隆") error:nil];
//	for (ZBRoute *route in routes) {
//		NSLog(@"%@", route.stringPresentation);
//	}
//}
//
//- (void)testExample2
//{
//	NSArray *routes = [manager possibleRoutesFromNode:NODE(@"基隆") toNode:NODE(@"八堵") error:nil];
//	for (ZBRoute *route in routes) {
//		NSLog(@"%@", route.stringPresentation);
//	}
//}
//
//- (void)testExample3
//{
//	NSArray *routes = [manager possibleRoutesFromNode:NODE(@"八堵") toNode:NODE(@"基隆") error:nil];
//	for (ZBRoute *route in routes) {
//		NSLog(@"%@", route.stringPresentation);
//	}
//}
//
//- (void)testExample4
//{
//	NSArray *routes = [manager possibleRoutesFromNode:NODE(@"國姓") toNode:NODE(@"基隆") error:nil];
//	for (ZBRoute *route in routes) {
//		NSLog(@"%@", route.stringPresentation);
//	}
//}


@end
