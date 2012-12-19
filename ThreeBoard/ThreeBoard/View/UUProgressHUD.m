//
//  UUProgressHUD.m
//  ThreeBoard
//
//  Created by garyliu on 12-12-19.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUProgressHUD.h"

@implementation UUProgressHUD

+ (void)showProgressHUDForView:(UIView *)view
{
    [MBProgressHUD showHUDAddedTo:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    hud.labelText = @"载入中...";
    hud.opacity = 0.6;
    hud.labelFont = [UIFont fontWithName:UU_CUSTOM_BODY_FONT size:16];
    
}

+ (void)hideProgressHUDForView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:NO];
}

@end
