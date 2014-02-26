#import <Foundation/Foundation.h>
#import "ZBNode.h"
#import "ZBLink.h"

@interface ZBRoute : NSObject

- (instancetype)initWithBeginNode:(ZBNode *)inBeginNode links:(NSArray *)inLinks;
- (NSString *)stringPresentation;

@property (readonly) ZBNode *beginNode;
@property (readonly) NSArray *links;
@property (readonly) double totalPrice;

@end
