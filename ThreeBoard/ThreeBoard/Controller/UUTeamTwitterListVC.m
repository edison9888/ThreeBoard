//
//  UUTeamTwitterListVC.m
//  ThreeBoard
//
//  Created by garyliu on 12-12-15.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUTeamTwitterListVC.h"
#import "UUAboutCell.h"
#import "SVWebViewController.h"

@interface UUTeamTwitterListVC ()

@property (nonatomic, strong) NSArray *arrTitle;
@property (nonatomic, strong) NSArray *arrTwitterURLStr;

@end

@implementation UUTeamTwitterListVC

@synthesize arrTitle;
@synthesize arrTwitterURLStr;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.arrTitle = [NSArray arrayWithObjects:@"金元证券新三板-华东部",@"新三板观察",@"欧阳昌", nil];
        self.arrTwitterURLStr = [NSArray arrayWithObjects:@"http://weibo.com/jyzqotc",@"http://weibo.com/u/2422133154",@"http://weibo.com/ouyangchang", nil];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.navigationItem.title = @"团队微博";
    self.tableView.backgroundColor = UU_BG_WHITE;
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCommonLowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrTitle count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UUAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UUAboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.imageView.image = [UIImage imageNamed:@"about_icon_weibo.png"];
    }
    
    cell.textLabel.text = [self.arrTitle objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:[self.arrTwitterURLStr objectAtIndex:indexPath.row]]];
    webViewController.availableActions = SVWebViewControllerAvailableActionsNone;
    webViewController.view.backgroundColor = UU_BG_WHITE;
    webViewController.navigationItem.title = [self.arrTitle objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:webViewController animated:YES];
    
}

@end
