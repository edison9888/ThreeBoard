//
//  UUBaseVC.h
//  ThreeBoard
//
//  Created by garyliu on 12-12-9.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"

@interface UUBaseVC : UITableViewController <PullTableViewDelegate>

@property (nonatomic, strong) PullTableView *pullTableView;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UIScrollView *focusScrollView;
@property (nonatomic, strong) UIPageControl *focusPageControl;
@property (nonatomic, strong) NSMutableArray *focusViews;
@property (nonatomic) int numberOfFocusPages;

- (void)loadVisibleCellsImage;
- (void)focusViewClicked:(id)sender;

@end
