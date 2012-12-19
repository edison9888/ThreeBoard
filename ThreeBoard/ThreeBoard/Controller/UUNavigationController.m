//
//  UUNavigationController.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-29.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUNavigationController.h"




@implementation UUNavigationController

- (void)loadView
{
    [super loadView];
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [[UIImage imageNamed:@"navigationbar_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 4, 10, 4)];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


