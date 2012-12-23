//
//  BWXShareSettingViewController.h
//  BWXUIKit
//
//  Created by easy on 12-10-18.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>


#ifdef BUILD_Framework
#import <BWXUIKitBase/BWXUIKitBase.h>
#else
#import "BWXViewController.h"
#endif
//分享设置页
@interface BWXShareSettingViewController : BWXViewController
-(id) init;
-(id) initWithServiceTypes:(NSArray *) serviceTypes;
@end
