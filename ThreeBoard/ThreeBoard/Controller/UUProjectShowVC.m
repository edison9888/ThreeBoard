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
@property (nonatomic, strong) UUCategory *categoryInfo;
@property (nonatomic, strong) SDSegmentedControl *segmentControl;

- (void)loadCategoryInfo;
- (void)segmentValueChanged:(id)sender;

@end

@implementation UUProjectShowVC

@synthesize currentPageIndex;
@synthesize categoryInfo;
@synthesize segmentControl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        categoryInfo = [[UUCategory alloc] init];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    
    self.pullTableView.tableHeaderView = nil;
    
    self.navigationItem.title = @"项目展示";
    
    self.segmentControl = [[SDSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"北京地区",@"长三角",@"珠三角",@"其他地区", nil]];
    self.segmentControl.frame = CGRectMake(0, 0, 320, 44);
    self.segmentControl.interItemSpace = 20;
    [self.segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentControl];
//    self.pullTableView.tableHeaderView = self.segmentControl;
    
    CGRect tableViewFrame = self.pullTableView.frame;
    tableViewFrame.origin.y = tableViewFrame.origin.y + 44;
//    tableViewFrame.size.height = tableViewFrame.size.height - 44;
    self.pullTableView.frame = tableViewFrame;
    [self.view addSubview:self.pullTableView];
    
    //fetch data when loading view
    self.currentPageIndex = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [MBProgressHUD HUDForView:self.view].labelText = @"载入中...";
    [self loadCategoryInfo];
    
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
}

#pragma mark - UUCategoryDataProvider Delegate

- (void) activityDetailFetched:(UUCategory *)category
{
    
    //stop loading animating and notify user
    [MBProgressHUD hideHUDForView:self.view animated:NO];
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
    }
    [self.tableView reloadData];
    [self loadVisibleCellsImage];
    
}

- (void) activityDetailFailed:(NSError *)error
{
    if(self.currentPageIndex > 0){
        self.currentPageIndex -- ;
    }
    
    //stop loading animating
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if(self.currentPageIndex == 0){
        self.pullTableView.pullTableIsRefreshing = NO;
    }else {
        self.pullTableView.pullTableIsLoadingMore = NO;
    }
    
    //notify user
    [AJNotificationView showNoticeInView:self.navigationController.view
                                    type:AJNotificationTypeRed
                                   title:@"联网失败，请重试"
                         linedBackground:AJLinedBackgroundTypeStatic
                               hideAfter:1.0f
                                  offset:65.0f];
}



#pragma mark - private methods

- (void)loadCategoryInfo
{
    [UUCategoryDataProvider sharedInstance].delegate = self;
    [[UUCategoryDataProvider sharedInstance] fetchActivityDetailWithPageIndex:currentPageIndex];
}

- (void)segmentValueChanged:(id)sender
{
    SDSegmentedControl *segment = (SDSegmentedControl *)sender;
    DDLogInfo(@"select index %d",segment.selectedSegmentIndex);
    
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
