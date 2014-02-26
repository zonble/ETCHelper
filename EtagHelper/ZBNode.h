#import <Foundation/Foundation.h>

@interface ZBNode : NSObject

- (instancetype)initWithName:(NSString *)inName;
- (void)makeLinkTowardNode:(ZBNode *)inNode forPrice:(double)inPrice tag:(NSString *)inTag;
- (NSArray *)linksBesideTowardNodes:(NSSet *)inNodes;

@property (readonly) NSString *name;
@property (readonly) NSArray *links;
@end

void makeLinkBetweenNodes(ZBNode *aNode, ZBNode *bNode, double price, NSString *tag);
