#import "ZBLink.h"

@interface ZBLink ()
{
	ZBNode *to;
	double price;
	NSString *tag;
}
@end

@implementation ZBLink

- (instancetype)initWithNode:(ZBNode *)toNode price:(double)inPrice tag:(NSString *)inTag
{
    self = [super init];
    if (self) {
        to = toNode;
		price = inPrice;
		tag = inTag;
    }
    return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ %p to:%@ price:%f tag:%@>", NSStringFromClass([self class]), self, to.name, price, tag];
}

@synthesize to, price, tag;
@end
