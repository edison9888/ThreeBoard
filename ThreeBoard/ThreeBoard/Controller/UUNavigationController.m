//
//  UUNavigationController.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-29.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUNavigationController.h"

@interface UUNavigationController ()

@end

@implementation UUNavigationController

- (void)loadView
{
    [super loadView];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"common_title_bgk.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
