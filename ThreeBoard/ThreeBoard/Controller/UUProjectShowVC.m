//
//  UUProjectShowVC.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-29.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUProjectShowVC.h"
#import "UUCategoryDataProvider.h"
#import "UUImageCell.h"
#import "MBProgressHUD.h"
#import "UUSectionHeaderView.h"
#import "AJNotificationView.h"
#import "UIImageView+WebCache.h"
#import "UUFocusView.h"
#import "SDSegmentedControl.h"

@interface UUProjectShowVC ()

@property (nonatomic) int currentPageIndex;
@property (nonatomic) int currentArea;
@property (nonatomic, strong) UUCategory *categoryInfo;
@property (nonatomic, strong) SDSegmentedControl *segmentControl;

- (void)loadCategoryInfo;
- (void)categoryInfoFetched:(UUCategory *)category;
- (void)categoryInfoFetchedFailed:(NSError *)error;
- (void)segmentValueChanged:(id)sender;

@end

@implementation UUProjectShowVC

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
//    self.navigationItem.title = @"项目展示";
    
    self.segmentControl = [[SDSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"北京地区",@"长三角",@"珠三角",@"其他地区", nil]];
    self.segmentControl.frame = CGRectMake(0, 0, 320, 44);
    self.segmentControl.interItemSpace = 20;
    [self.segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentControl];
    
    CGRect tableViewFrame = self.pullTableView.frame;
    tableViewFrame.origin.y = tableViewFrame.origin.y + 44;
    tableViewFrame.size.height = tableViewFrame.size.height - 44;
    self.pullTableView.frame = tableViewFrame;
    self.emptyView.frame = tableViewFrame;
    
    //fetch data when loading view
    self.currentPageIndex = 0;
    self.currentArea = ProjectShowAreaBeijing;
    self.segmentControl.selectedSegmentIndex = ProjectShowAreaBeijing;
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
    return kCommonSectionHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCommonHighHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sectionCount = [self.categoryInfo.listPages count];
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *pagesDic = [self.categoryInfo.listPages objectAtIndex:section];
    NSString *title = [[pagesDic allKeys] objectAtIndex:0];
    NSArray *pages = [pagesDic objectForKey:title];
    if(pages){
        return [pages count];
    }else{
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UUSectionHeaderView *sectionHeaderView = [[UUSectionHeaderView alloc] init];
    
    NSDictionary *pagesDic = [self.categoryInfo.listPages objectAtIndex:section];
    NSString *title = [[pagesDic allKeys] objectAtIndex:0];
    sectionHeaderView.titleLabel.text = title;
    
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UUImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UUImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    int sectionIndex = indexPath.section;
    int rowIndex = indexPath.row;
    NSDictionary *pagesDic = [self.categoryInfo.listPages objectAtIndex:sectionIndex];
    NSString *title = [[pagesDic allKeys] objectAtIndex:0];
    NSArray *pages = [pagesDic objectForKey:title];
    UUPage *page = [pages objectAtIndex:rowIndex];
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
    int sectionIndex = indexPath.section;
    int rowIndex = indexPath.row;
    NSDictionary *pagesDic = [self.categoryInfo.listPages objectAtIndex:sectionIndex];
    NSString *title = [[pagesDic allKeys] objectAtIndex:0];
    NSArray *pages = [pagesDic objectForKey:title];
    UUPage *page = [pages objectAtIndex:rowIndex];
    UUPageVC *pageVC = [[UUPageVC alloc] initWithPageID:page.pageID];
    [self.navigationController pushViewController:pageVC animated:YES];
    pageVC.navigationItem.title = kPageTitleProjectShow;
}

#pragma mark - UUCategoryDataProvider Delegate

- (void)beijingAreaDetailFetched:(UUCategory *)category
{
    if(self.currentArea == ProjectShowAreaBeijing){
        [self categoryInfoFetched:category];
    }
}

- (void)changjiangAreaDetailFetched:(UUCategory *)category
{
    if(self.currentArea == ProjectShowAreaChangjiang){
        [self categoryInfoFetched:category];
    }
}

- (void)zhujiangAreaDetailFetched:(UUCategory *)category
{
    if(self.currentArea == ProjectShowAreaZhujiang){
        [self categoryInfoFetched:category];
    }
}

- (void)otherAreaDetailFetched:(UUCategory *)category
{
    if(self.currentArea == ProjectShowAreaOther){
        [self categoryInfoFetched:category];
    }
}

- (void)beijingAreaDetailFailed:(NSError *)error
{
    [self categoryInfoFetchedFailed:error];
}

- (void)changjiangAreaDetailFailed:(NSError *)error
{
    [self categoryInfoFetchedFailed:error];
}

- (void)zhujiangAreaDetailFailed:(NSError *)error
{
    [self categoryInfoFetchedFailed:error];
}

- (void)otherAreaDetailFailed:(NSError *)error
{
    [self categoryInfoFetchedFailed:error];
}

#pragma mark - private methods

- (void)loadCategoryInfo
{
    [UUCategoryDataProvider sharedInstance].delegate = self;
    switch (self.currentArea) {
        case ProjectShowAreaBeijing:
            [[UUCategoryDataProvider sharedInstance] fetchBeijingAreaDetailWithPageIndex:currentPageIndex];
            break;
        case ProjectShowAreaChangjiang:
            [[UUCategoryDataProvider sharedInstance] fetchChangjiangAreaDetailWithPageIndex:currentPageIndex];
            break;
        case ProjectShowAreaZhujiang:
            [[UUCategoryDataProvider sharedInstance] fetchZhujiangAreaDetailWithPageIndex:currentPageIndex];
            break;
        case ProjectShowAreaOther:
            [[UUCategoryDataProvider sharedInstance] fetchOtherAreaDetailWithPageIndex:currentPageIndex];
            break;
        default:
            break;
    }
    
}

- (void)categoryInfoFetched:(UUCategory *)category
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
        NSMutableArray *deltaPageSections = category.listPages;
        NSMutableArray *pageSections = self.categoryInfo.listPages;
        for(NSMutableDictionary *deltaSection in deltaPageSections){
            NSString *deltaSectionTitle = [[deltaSection allKeys] objectAtIndex:0];
            int lastIndex = ([pageSections count]>0)?[pageSections count] -1 : 0;
            NSMutableDictionary *lastSection = [pageSections objectAtIndex:lastIndex];
            NSString *lastSectionTitle = [[lastSection allKeys] objectAtIndex:0];
            //if section title is equal to last section title of previous page
            if([deltaSectionTitle isEqualToString:lastSectionTitle]){
                NSMutableArray *deltaSectionPages = [deltaSection objectForKey:deltaSectionTitle];
                NSMutableArray *lastSectionPages = [lastSection objectForKey:lastSectionTitle];
                [lastSectionPages addObjectsFromArray:deltaSectionPages];
            }else{
                [pageSections addObject:deltaSection];
            }
        }
        CGFloat offsetY = [UIScreen mainScreen].bounds.origin.y+[UIScreen mainScreen].bounds.size.height + kCommonHighHeight;
        [self.pullTableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
    [self.pullTableView reloadData];
    [self loadVisibleCellsImage];
}


- (void)categoryInfoFetchedFailed:(NSError *)error
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
