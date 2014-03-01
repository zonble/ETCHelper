#import "ZBRootTableViewController.h"
#import "ZBFreewaysTableViewController.h"
#import "ZBRoutesTableViewController.h"
#import "ZBRouteTableViewController.h"
#import "ZBRouteManager.h"

static NSString *const CellIdentifier = @"Cell";

@interface ZBRootTableViewController () <ZBFreewaysTableViewControllerDelegate>
@property (strong, nonatomic) ZBRouteManager *manager;
@property (strong, nonatomic) ZBFreewaysTableViewController *fromPicker;
@property (strong, nonatomic) ZBFreewaysTableViewController *toPicker;
@property (strong, nonatomic) ZBNode *from;
@property (strong, nonatomic) ZBNode *to;
@end

@implementation ZBRootTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		self.title = NSLocalizedString(@"ETC Helper", @"");
		self.manager = [[ZBRouteManager alloc] initWithRoutingDataFileURL:[[NSBundle mainBundle] URLForResource:@"data" withExtension:@"txt"]];
		self.fromPicker = [[ZBFreewaysTableViewController alloc] initWithStyle:UITableViewStylePlain];
		self.fromPicker.delegate = self;
		self.toPicker = [[ZBFreewaysTableViewController alloc] initWithStyle:UITableViewStylePlain];
		self.toPicker.delegate = self;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)findPossibleRoutes
{
#define ERROR(x) [[[UIAlertView alloc] initWithTitle:NSLocalizedString(x, @"") message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil] show]
	if (!self.from) {
		ERROR(NSLocalizedString(@"You did not set where to start!", @""));
		return;
	}
	if (!self.to) {
		ERROR(NSLocalizedString(@"You did not set where to end!", @""));
		return;
	}
	if (self.from == self.to) {
		ERROR(NSLocalizedString(@"The start and the end should be different!", @""));
		return;
	}
	NSArray *routes = [self.manager possibleRoutesFromNode:self.from toNode:self.to error:nil];

	if ([routes count] == 1) {
		ZBRouteTableViewController *controller = [[ZBRouteTableViewController alloc] initWithStyle:UITableViewStylePlain];
		controller.route = routes[0];
		[self.navigationController pushViewController:controller animated:YES];
	}
	else {
		ZBRoutesTableViewController *controller = [[ZBRoutesTableViewController alloc] initWithStyle:UITableViewStylePlain];
		controller.routes = routes;
		[self.navigationController pushViewController:controller animated:YES];
	}
#undef ERROR
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	cell.textLabel.textColor = [UIColor blackColor];
	cell.textLabel.textAlignment = NSTextAlignmentLeft;

	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = self.from ? self.from.name : NSLocalizedString(@"Not Set Yet", @"");
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 1:
			cell.textLabel.text = self.to ? self.to.name : NSLocalizedString(@"Not Set Yet", @"");
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 2:
			cell.textLabel.text = NSLocalizedString(@"Calculate", @"");
			cell.accessoryType = UITableViewCellSeparatorStyleNone;
			cell.textLabel.textColor = [UIColor blueColor];
			cell.textLabel.textAlignment = NSTextAlignmentCenter;
			break;
		default:
			break;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0:
			[self.navigationController pushViewController:self.fromPicker animated:YES];
			break;
		case 1:
			[self.navigationController pushViewController:self.toPicker animated:YES];
			break;
		case 2:
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			[self findPossibleRoutes];
			break;
		default:
			break;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section < 2) {
		NSString *s = @[@"From", @"To"][section];
		return NSLocalizedString(s, @"");
	}

	return nil;
}

- (ZBRouteManager *)routeManagerForFreewaysTableViewController:(ZBFreewaysTableViewController *)inController
{
	return self.manager;
}

- (void)routeManagerForFreewaysTableViewController:(ZBFreewaysTableViewController *)inController didSelectNode:(ZBNode *)inNode
{
	if (inController == self.fromPicker) {
		self.from = inNode;
	}
	else if (inController == self.toPicker) {
		self.to = inNode;
	}
	[self.tableView reloadData];
	[self.navigationController popToViewController:self animated:YES];
}

@end
