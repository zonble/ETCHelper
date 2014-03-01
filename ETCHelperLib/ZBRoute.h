#import <Foundation/Foundation.h>
#import "ZBNode.h"
#import "ZBLink.h"

/*! Data object for a route. */
@interface ZBRoute : NSObject

/*! Creates a new instance.
@param inBeginNode where the route begins
@param links in the route. */
- (instancetype)initWithBeginNode:(ZBNode *)inBeginNode links:(NSArray *)inLinks;

/*! A convinient method for reading the route. */
- (NSString *)stringPresentation;

/*! Where the route begins. */
@property (readonly) ZBNode *beginNode;
/*! Links in the route. */
@property (readonly) NSArray *links;
 /*! How much does driving on the route cost. */
@property (readonly) double totalPrice;
@end
