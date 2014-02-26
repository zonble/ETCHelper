#import "ZBRoute.h"

@interface ZBRoute ()
{
	ZBNode *beginNode;
	NSArray *links;
	double totalPrice;
}
@end

@implementation ZBRoute

- (void)_calculateTotalPrice
{
	for (ZBLink *link in links) {
		totalPrice += link.price;
	}
}

- (instancetype)initWithBeginNode:(ZBNode *)inBeginNode links:(NSArray *)inLinks
{
    self = [super init];
    if (self) {
		beginNode = inBeginNode;
		links = inLinks;
		[self _calculateTotalPrice];
    }
    return self;
}

- (NSString *)stringPresentation
{
	NSMutableString *s = [NSMutableString string];
	[s appendFormat:@"[%f] ", totalPrice];
	[s appendString:beginNode.name];
	for (ZBLink *link in links) {
		[s appendFormat:@"-(%@)-%@", link.tag, link.to.name];
	}
	return s;
}

@synthesize beginNode;
@synthesize links;
@synthesize totalPrice;

@end
