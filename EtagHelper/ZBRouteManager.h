#import <Foundation/Foundation.h>
#import "ZBNode.h"
#import "ZBLink.h"
#import "ZBRoute.h"

@interface ZBRouteManager : NSObject

- (instancetype)initWithRoutingDataFileURL:(NSURL *)inURL;

/*! Names could be found in the nodes or allNodeNames property. */
- (ZBNode *)nodeWithName:(NSString *)inName;
- (NSArray *)nodesOnFreeway:(NSString *)inName;
/*! returns an array of ZBRoute. */
- (NSArray *)possibleRoutesFromNode:(ZBNode *)fromNode toNode:(ZBNode *)toNode error:(NSError *)outError;

@property (readonly) NSSet *nodes;
@property (readonly) NSSet *allNodeNames;
@property (readonly) NSSet *allFreewayNames;
@end
