#import <Foundation/Foundation.h>
#import "ZBNode.h"

/*! Data object for a link. */
@interface ZBLink : NSObject

/*! Creates a new instance.
@param toNode where the link goes to
@param inPrice how much does driving on the link cost
@param tag actually it is the name of the freeway where the link
belongs to */
- (instancetype)initWithNode:(ZBNode *)toNode price:(double)inPrice tag:(NSString *)inTag;

/*! Where the link goes to. */
@property (readonly) ZBNode *to;
/*! How much does driving on the link cost. */
@property (readonly) double price;
/*! Actually it is the name of the freeway where the link belongs
to. */
@property (readonly) NSString *tag;
@end
