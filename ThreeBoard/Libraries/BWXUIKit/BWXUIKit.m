//
//  BWXUIKit.m
//  BWXUIKit
//
//  Created by Daly on 12-9-26.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "BWXUIKit.h"

@implementation BWXUIKit

+ (BOOL)isHorizontal
{
    bool bVertical = NO;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        //从竖屏翻转为横屏时
        bVertical = YES;
    }
    return !bVertical;
}

+ (BOOL)isIphone5
{
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    if (rect_screen.size.height == 568) {
        return YES;
    }
    return NO;
}

+ (float)nowScreenHeight
{
    if ([BWXUIKit isHorizontal]) {
        return [[UIScreen mainScreen] bounds].size.width;
    } else {
        return [[UIScreen mainScreen] bounds].size.height;
    }
}

+ (float)nowScreenWidth
{
    if ([BWXUIKit isHorizontal]) {
        return [[UIScreen mainScreen] bounds].size.height;
    } else {
        return [[UIScreen mainScreen] bounds].size.width;
    }
    
}


@end
