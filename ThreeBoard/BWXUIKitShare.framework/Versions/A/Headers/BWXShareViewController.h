//
//  BWXShareViewController.h
//  BWXUIKit
//
//  Created by easy on 12-10-17.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWXShareBaseService.h"


#ifdef BUILD_Framework
#import <BWXUIKitBase/BWXUIKitBase.h>
#else
#import "BWXViewController.h"

#endif

@class BWXShareServiceModel;

@interface BWXShareViewController : BWXViewController
@property (nonatomic, copy) NSArray *images;        //分享图片
@property (nonatomic, copy) NSString *content;      //分享内容
@property (nonatomic, retain) BWXShareBaseService *service;//服务模型
@end
