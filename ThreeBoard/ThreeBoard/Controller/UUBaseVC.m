//
//  UUBaseVC.m
//  ThreeBoard
//
//  Created by garyliu on 12-12-9.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUBaseVC.h"
#import "UUFocusView.h"
#import "UUImageCell.h"

static NSUInteger kNumberOfPages = 6;

@interface UUBaseVC ()

@property (nonatomic) BOOL pageControlUsed;

- (void)changePage:(id)sender;

@end

@implementation UUBaseVC

@synthesize pullTableView;
@synthesize emptyView;
@synthesize focusScrollView;
@synthesize focusPageControl;
@synthesize focusViews;
@synthesize pageControlUsed;
@synthesize numberOfFocusPages;


- (void)loadView
{
    [super loadView];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64)];
    self.view.backgroundColor = UU_BG_WHITE;
    
    self.pullTableView = [[PullTableView alloc] initWithFrame:self.view.frame];
    self.pullTableView.pullDelegate = self;
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullBackgroundColor = UU_BG_WHITE;
    self.pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pullTableView.backgroundColor = UU_BG_WHITE;
    self.pullTableView.backgroundView = nil;
    [self.view addSubview:self.pullTableView];
    
    //empty view
    self.emptyView = [[UIView alloc] initWithFrame:self.pullTableView.frame];
    self.emptyView.backgroundColor = UU_BG_WHITE;
    UILabel *emptyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    emptyTitleLabel.center = self.emptyView.center;
    emptyTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    emptyTitleLabel.backgroundColor = [UIColor clearColor];
    emptyTitleLabel.text = @"暂无数据";
    emptyTitleLabel.textAlignment = UITextAlignmentCenter;
    emptyTitleLabel.textColor = UU_TEXT_BLACK;
    emptyTitleLabel.font = [UIFont fontWithName:UU_CUSTOM_BODY_FONT size:16];
    [self.emptyView addSubview:emptyTitleLabel];
    
    //header focus pages
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 148)];
    headerView.backgroundColor = [UIColor clearColor];
    
    self.focusScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 148)];
    focusScrollView.pagingEnabled = YES;
    focusScrollView.contentSize = CGSizeMake(focusScrollView.frame.size.width * kNumberOfPages, focusScrollView.frame.size.height);
    focusScrollView.showsHorizontalScrollIndicator = NO;
    focusScrollView.showsVerticalScrollIndicator = NO;
    focusScrollView.bounces = NO;
    focusScrollView.scrollsToTop = NO;
    focusScrollView.delegate = self;
    [headerView addSubview:focusScrollView];
    
    self.focusViews = [NSMutableArray array];
    for(int i=0; i<kNumberOfPages; i++){
        UUFocusView *focusView = [[UUFocusView alloc] initWithFrame:CGRectMake(i*320, 0, 320, 148)];
        focusView.focusButton.tag = i;
        [focusView.focusButton addTarget:self action:@selector(focusViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.focusViews addObject:focusView];
        [focusScrollView addSubview:focusView];
    }
    
    self.focusPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(200, 112, 120, 36)];
    [focusPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    focusPageControl.numberOfPages = kNumberOfPages;
    focusPageControl.currentPage = 0;
    focusPageControl.backgroundColor = [UIColor clearColor];
    [headerView addSubview:focusPageControl];
    
    self.pullTableView.tableHeaderView = headerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - private methods

- (void)changePage:(id)sender
{
    int page = focusPageControl.currentPage;
    
	// update the scroll view to the appropriate page
    CGRect frame = focusScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [focusScrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

#pragma mark - protected methods

- (void)loadVisibleCellsImage
{
    NSArray *cells = [self.pullTableView visibleCells];
    for(UUImageCell *cell in cells){
        if([cell respondsToSelector:@selector(showImage)]){
            [cell showImage];
        }
    }
}


- (void)focusViewClicked:(id)sender
{
    
}


- (void)focusViewClickedWithData:(NSArray *)focusPages title:(NSString *)title
{
    int currenFocusIndex = self.focusPageControl.currentPage;
    if(focusPages && [focusPages count] > 0 && currenFocusIndex < [focusPages count]){
        UUPage *page = [focusPages objectAtIndex:currenFocusIndex];
        UUPageVC *pageVC = [[UUPageVC alloc] initWithPageID:page.pageID];
        [self.navigationController pushViewController:pageVC animated:YES];
        pageVC.navigationItem.title = title;
    }
}

#pragma mark - uiscrollview delegate


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if(sender == self.focusScrollView){
        // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
        // which a scroll event generated from the user hitting the page control triggers updates from
        // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
        if (pageControlUsed)
        {
            // do nothing - the scroll was initiated from the page control, not the user dragging
            return;
        }
        
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = focusScrollView.frame.size.width;
        int page = floor((focusScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        focusPageControl.currentPage = page;
    }
}


// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == self.focusScrollView){
        pageControlUsed = NO;
    }
    
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self.focusScrollView){
        pageControlUsed = NO;
    }else{
        [self loadVisibleCellsImage];
    }
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
}


@end
