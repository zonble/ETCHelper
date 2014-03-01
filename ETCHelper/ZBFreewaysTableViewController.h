#import <UIKit/UIKit.h>
#import "ZBRouteManager.h"

@class ZBFreewaysTableViewController;
@protocol ZBFreewaysTableViewControllerDelegate <NSObject>
- (ZBRouteManager *)routeManagerForFreewaysTableViewController:(ZBFreewaysTableViewController *)inController;
- (void)routeManagerForFreewaysTableViewController:(ZBFreewaysTableViewController *)inController didSelectNode:(ZBNode *)inNode;
@end

@interface ZBFreewaysTableViewController : UITableViewController
@property (weak, nonatomic) id <ZBFreewaysTableViewControllerDelegate> delegate;
@end
