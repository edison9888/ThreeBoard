//
//  UUProgressHUD.h
//  ThreeBoard
//
//  Created by garyliu on 12-12-19.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface UUProgressHUD : NSObject


+ (void)showProgressHUDForView:(UIView *)view;

+ (void)hideProgressHUDForView:(UIView *)view;

@end
