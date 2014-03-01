#import "ZBRoutesTableViewController.h"
#import "ZBRouteTableViewController.h"
#import "ZBRoute.h"

@interface ZBRoutesTableViewController ()
@end

@implementation ZBRoutesTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Routes", @"");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.routes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	}

	ZBRoute *route = self.routes[indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Route %d", @""), indexPath.row + 1];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f", route.totalPrice];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ZBRoute *route = self.routes[indexPath.row];
	ZBRouteTableViewController *controller = [[ZBRouteTableViewController alloc] initWithStyle:UITableViewStylePlain];
	controller.route = route;
	[self.navigationController pushViewController:controller animated:YES];
}

@end
