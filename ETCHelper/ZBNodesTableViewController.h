#import <UIKit/UIKit.h>
#import "ZBNode.h"

@class ZBNodesTableViewController;
@protocol ZBNodesTableViewControllerDelegate <NSObject>
- (void)nodesTableViewController:(ZBNodesTableViewController *)inController didSelectNode:(ZBNode *)inNode;
@end

@interface ZBNodesTableViewController : UITableViewController
@property (weak, nonatomic) id <ZBNodesTableViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *nodes;
@end
