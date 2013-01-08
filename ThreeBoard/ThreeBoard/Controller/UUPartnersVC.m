//
//  UUPartnersVC.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-29.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUPartnersVC.h"
#import "UUCategoryDataProvider.h"
#import "UUImageCell.h"
#import "MBProgressHUD.h"
#import "UUSectionHeaderView.h"
#import "AJNotificationView.h"
#import "UIImageView+WebCache.h"
#import "UUFocusView.h"
#import "SDSegmentedControl.h"

@interface UUPartnersVC ()

@property (nonatomic) int currentPageIndex;
@property (nonatomic) int currentArea;
@property (nonatomic, strong) UUCategory *categoryInfo;
@property (nonatomic, strong) SDSegmentedControl *segmentControl;

- (void)loadCategoryInfo;
- (void)segmentValueChanged:(id)sender;

@end

@implementation UUPartnersVC

@synthesize currentPageIndex;
@synthesize currentArea;
@synthesize categoryInfo;
@synthesize segmentControl;

- (void)loadView
{
    [super loadView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pullTableView.tableHeaderView = nil;
    
//    self.segmentControl = [[SDSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"企业伙伴",@"投资公司",@"专家会员",@"战略伙伴", nil]];
    self.segmentControl = [[SDSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"投资公司",@"战略伙伴",@"企业客户",@"专家顾问", nil]];
    
    self.segmentControl.frame = CGRectMake(0, 0, 320, 44);
    self.segmentControl.interItemSpace = 10;
    [self.segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentControl];
    
    CGRect tableViewFrame = self.pullTableView.frame;
    tableViewFrame.origin.y = tableViewFrame.origin.y + 44;
    tableViewFrame.size.height = tableViewFrame.size.height - 44;
    self.pullTableView.frame = tableViewFrame;
    self.emptyView.frame = tableViewFrame;
    
    //fetch data when loading view
    self.currentPageIndex = 0;
    self.currentArea = PartnersTypePartnerEnterprise;
    self.segmentControl.selectedSegmentIndex = PartnersTypePartnerEnterprise;
    [self loadCategoryInfo];
    
    [UUProgressHUD showProgressHUDForView:self.view];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UUCategoryDataProvider sharedInstance].delegate = nil;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCommonHighHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *pages = self.categoryInfo.listPages;
    return [pages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UUImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UUImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    int rowIndex = indexPath.row;
    
    UUPage *page = [self.categoryInfo.listPages objectAtIndex:rowIndex];
    cell.textLabel.text = page.pageTitle;
    cell.detailTextLabel.text = page.summary;
    cell.imageURL = page.thumbImageURL;
    [cell showImage];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int rowIndex = indexPath.row;
    UUPage *page = [self.categoryInfo.listPages objectAtIndex:rowIndex];
    UUPageVC *pageVC = [[UUPageVC alloc] initWithPageID:page.pageID];
    [self.navigationController pushViewController:pageVC animated:YES];
    pageVC.navigationItem.title = kPageTitlePartners;
}

#pragma mark - UUCategoryDataProvider Delegate

- (void)partnerDetailFetched:(UUCategory *)category
{
    //stop loading animating and notify user
    [UUProgressHUD hideProgressHUDForView:self.view];
    self.categoryInfo.hasmore = category.hasmore;
    if(self.currentPageIndex == 0){
        self.pullTableView.pullTableIsRefreshing = NO;
        if(!category.hasmore){
            //there is only one page
            [self.pullTableView removeFooterView];
        }else{
            [self.pullTableView addFooterView];
        }
    }else if(self.currentPageIndex > 0 && category.hasmore){
        //if there are more pages still could load more pages
        self.pullTableView.pullTableIsLoadingMore = NO;
    }else if(!category.hasmore){
        //it is the last page
        self.pullTableView.pullTableIsLoadingMore = NO;
        [self.pullTableView removeFooterView];
    }
    
    //data fetched
    if(self.currentPageIndex == 0){
        //first page
        if([category.listPages count] > 0){
            self.categoryInfo = category;
            if(self.emptyView){
                [self.emptyView removeFromSuperview];
            }
        }else{
            if(self.emptyView){
                [self.view addSubview:self.emptyView];
            }
            return;
        }
    }else{
        //other page, append data to current data
        NSArray *deltaPages = category.listPages;
        if([self.categoryInfo.listPages count] > 0){
            for(UUPage *page in deltaPages){
                [self.categoryInfo.listPages addObject:page];
            }
        }else{
            self.categoryInfo = category;
        }
        
        CGFloat offsetY = [UIScreen mainScreen].bounds.origin.y+[UIScreen mainScreen].bounds.size.height + kCommonHighHeight;
        [self.pullTableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
    [self.pullTableView reloadData];
    [self loadVisibleCellsImage];
}


- (void)partnerDetailFailed:(NSError *)error
{
    if(self.currentPageIndex > 0){
        self.currentPageIndex -- ;
    }
    
    //stop loading animating
    [UUProgressHUD hideProgressHUDForView:self.view];
    if(self.currentPageIndex == 0){
        self.pullTableView.pullTableIsRefreshing = NO;
    }else {
        self.pullTableView.pullTableIsLoadingMore = NO;
    }
    
    //notify user
    [AJNotificationView showNoticeInView:self.navigationController.view
                                    type:AJNotificationTypeRed
                                   title:@"出错了，请重试"
                         linedBackground:AJLinedBackgroundTypeStatic
                               hideAfter:1.0f
                                  offset:65.0f];
}

#pragma mark - private methods

- (void)loadCategoryInfo
{
    [UUCategoryDataProvider sharedInstance].delegate = self;
    [[UUCategoryDataProvider sharedInstance] fetchPartnersDetailWithType:self.currentArea pageIndex:currentPageIndex];
}



- (void)segmentValueChanged:(id)sender
{
    int selectedArea = self.segmentControl.selectedSegmentIndex;
    if(selectedArea != self.currentArea){
        [UUCategoryDataProvider sharedInstance].delegate = nil;
        self.currentArea = self.segmentControl.selectedSegmentIndex;
        self.currentPageIndex = 0;
        self.pullTableView.pullTableIsRefreshing = YES;
        [self loadCategoryInfo];
    }
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    //restart from first page
    self.currentPageIndex = 0;
    [self loadCategoryInfo];
    
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    if(self.categoryInfo.hasmore){
        self.currentPageIndex ++;
        [self loadCategoryInfo];
    }
}

@end
