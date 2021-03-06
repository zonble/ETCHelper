#import "ZBAppDelegate.h"
#import "ZBRootTableViewController.h"

@implementation ZBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	ZBRootTableViewController *rootViewController = [[ZBRootTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
	self.window.rootViewController = navController;
	[self.window makeKeyAndVisible];
	return YES;
}

@end
