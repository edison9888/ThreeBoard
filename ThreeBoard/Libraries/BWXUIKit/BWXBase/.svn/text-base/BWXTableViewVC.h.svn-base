//
//  WXTableViewViewController.h
//  WXUIKit
//
//  Created by Daly Dai on 12-7-14.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWXViewController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "BWXCustomCell.h"
@interface BWXTableViewVC :BWXViewController <UITableViewDelegate, UITableViewDataSource,EGORefreshTableFooterDelegate, EGORefreshTableHeaderDelegate,MBProgressHUDDelegate>
{
    UITableView *tableView;	
    NSInteger currentPage;
	BOOL isPullLoadMore;
    BOOL isLoading;


}

@property(nonatomic,copy)UIView *waitingLoadDataView;


// add pull down view for refresh
- (void)addPullRefresh;
// add pull up view for loading more
- (void)addPullLoadMore;


- (void)showLoading;
- (void)hiddenLoading;

- (void)refreshData;
- (void)loadMoreData;


- (void)finishLoadMoreData;
- (void)finishRefreshingData;

- (void)noMoreData;


- (void)setTableHeaderView:(UIView*)headerView;
@end
