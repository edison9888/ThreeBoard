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
    
//    int height = self.navigationBar.frame.size.height;
//    int width = self.navigationBar.frame.size.width;
//    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    navLabel.backgroundColor = [UIColor clearColor];
//    navLabel.textColor = [UIColor greenColor];
//    navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    navLabel.font = [UIFont fontWithName:UU_CUSTOM_BODY_FONT size:16];
//    navLabel.textAlignment = UITextAlignmentCenter;
//    self.navigationItem.titleView = navLabel;
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


