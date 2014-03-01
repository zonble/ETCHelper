#import "ZBRouteTableViewController.h"

@implementation ZBRouteTableViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.title = [NSString stringWithFormat:@"Total: NTD %.1f", self.route.totalPrice];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.route.links count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}

	ZBLink *link = self.route.links[indexPath.row];
	ZBNode *to = [link to];
	NSString *tag = link.tag;
	ZBNode *from = (indexPath.row == 0) ? self.route.beginNode : [self.route.links[indexPath.row - 1] to];
	cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", from.name, to.name];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - NTD %.1f", tag, link.price];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

@end
