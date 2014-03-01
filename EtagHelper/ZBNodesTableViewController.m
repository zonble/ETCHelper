#import "ZBNodesTableViewController.h"
static NSString *const CellIdentifier = @"Cell";

@interface ZBNodesTableViewController ()

@end

@implementation ZBNodesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	ZBNode *node = self.nodes[indexPath.row];
	cell.textLabel.text = node.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ZBNode *node = self.nodes[indexPath.row];
	[self.delegate nodesTableViewController:self didSelectNode:node];
}

@end
