#import <Foundation/Foundation.h>
#import "ZBNode.h"

@interface ZBLink : NSObject
- (instancetype)initWithNode:(ZBNode *)toNode price:(double)inPrice tag:(NSString *)inTag;
@property (readonly) ZBNode *to;
@property (readonly) double price;
@property (readonly) NSString *tag;
@end
