//
//  UUAboutVC.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-29.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUAboutVC.h"
#import "UUAboutCell.h"
#import "SVWebViewController.h"
#import "UUTeamTwitterListVC.h"
#import "BWXShareCenter.h"

@interface UUAboutVC ()

@property (nonatomic, strong) NSArray *arrTitle;
@property (nonatomic, strong) NSArray *arrImageStr;
@property (nonatomic, strong) NSArray *arrVC;

@end

@implementation UUAboutVC

@synthesize arrTitle;
@synthesize arrImageStr;
@synthesize arrVC;

- (id)init
{
    self = [super init];
    if(self){
        self.arrTitle = [NSArray arrayWithObjects:@"关于金元证券",@"团队微博",@"联系方式",@"版本信息",@"分享设置", nil];
        self.arrImageStr = [NSArray arrayWithObjects:@"about_icon_jinyuan.png",@"about_icon_weibo.png",@"about_icon_contact.png",@"about_icon_version.png",@"about_icon_weibo.png", nil];
        
    }
    return self;
}


- (void)loadView
{
    [super loadView];
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
    return AboutSectionNumber;
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
    }
    
    cell.textLabel.text = [self.arrTitle objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[self.arrImageStr objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == AboutSectionJinyuan){
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]isDirectory:NO];
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:url];
        webViewController.availableActions = SVWebViewControllerAvailableActionsNone;
        webViewController.view.backgroundColor = UU_BG_WHITE;
        webViewController.navigationItem.title = @"关于金元证券";
        [self.navigationController pushViewController:webViewController animated:YES];
    }else if(indexPath.row == AboutSectionTeamWeibo){
        [self.navigationController pushViewController:[[UUTeamTwitterListVC alloc] init] animated:YES];
    }else if(indexPath.row == AboutSectionContact){
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.gouqi001.com/jinyuan/contact.html"]];
        webViewController.availableActions = SVWebViewControllerAvailableActionsNone;
        webViewController.view.backgroundColor = UU_BG_WHITE;
        webViewController.navigationItem.title = @"联系方式";
        [self.navigationController pushViewController:webViewController animated:YES];
    }else if(indexPath.row == AboutSectionVersionInfo){
//        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"smartnews" ofType:@"html"]isDirectory:NO];
        NSURL *url = [NSURL URLWithString:@"http://www.gouqi001.com/jinyuan/version.html"];
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:url];
        webViewController.availableActions = SVWebViewControllerAvailableActionsNone;
        webViewController.view.backgroundColor = UU_BG_WHITE;
        webViewController.navigationItem.title = @"版本信息";
        [self.navigationController pushViewController:webViewController animated:YES];
    }else if(indexPath.row == ShareSettings){
        UIViewController *shareSettingVC = [BWXShareCenterInstance settingViewController];
        shareSettingVC.navigationItem.title = @"分享设置";
        [self.navigationController pushViewController:shareSettingVC animated:YES];
    }
    
}


@end
