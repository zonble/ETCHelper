#import "ZBFreewaysTableViewController.h"
#import "ZBNodesTableViewController.h"

static NSString *const CellIdentifier = @"Cell";

@interface ZBFreewaysTableViewController () <ZBNodesTableViewControllerDelegate>
@property (strong, nonatomic) NSArray *freewayNames;
@end

@implementation ZBFreewaysTableViewController

- (void)viewDidLoad
{
	ZBRouteManager *manager = [self.delegate routeManagerForFreewaysTableViewController:self];
	NSArray *names = [manager.allFreewayNames allObjects];
	self.freewayNames = [names sortedArrayUsingSelector:@selector(localizedCompare:)];

	[super viewDidLoad];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
	self.clearsSelectionOnViewWillAppear = YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.freewayNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	cell.textLabel.text = self.freewayNames[indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSString *name = self.freewayNames[indexPath.row];
	ZBRouteManager *manager = [self.delegate routeManagerForFreewaysTableViewController:self];
	NSArray *nodes = [manager nodesOnFreeway:name];

	ZBNodesTableViewController *controller = [[ZBNodesTableViewController alloc] initWithStyle:UITableViewStylePlain];
	controller.delegate = self;
	controller.nodes = nodes;
	controller.title = name;
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)nodesTableViewController:(ZBNodesTableViewController *)inController didSelectNode:(ZBNode *)inNode
{
	[self.delegate routeManagerForFreewaysTableViewController:self didSelectNode:inNode];
}

@end
