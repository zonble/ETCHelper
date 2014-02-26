#import <Foundation/Foundation.h>
#import "ZBNode.h"
#import "ZBLink.h"
#import "ZBRoute.h"

/*! A manager for maintaining the model built by nodes and links for
illustrating the routes on freeways in Taiwan. */
@interface ZBRouteManager : NSObject

/*! Creates a new instance by giving the URL of the file for building
data model. */
- (instancetype)initWithRoutingDataFileURL:(NSURL *)inURL;

/*! Returns a node by giving the name of the node. Node names could be
found in the nodes or allNodeNames property. */
- (ZBNode *)nodeWithName:(NSString *)inName;

/*! Returns an array of nodes belong to a highway by giving the name
of the freeway. The highway named could be found in the
allFreewayNames property. */
- (NSArray *)nodesOnFreeway:(NSString *)inName;

/*! Returns an array of possible routes. */
- (NSArray *)possibleRoutesFromNode:(ZBNode *)fromNode toNode:(ZBNode *)toNode error:(NSError *)outError;

/*! All nodes. */
@property (readonly) NSSet *nodes;
/*! Names of all nodes. */
@property (readonly) NSSet *allNodeNames;
/*! Names of all freeways. */
@property (readonly) NSSet *allFreewayNames;
@end
