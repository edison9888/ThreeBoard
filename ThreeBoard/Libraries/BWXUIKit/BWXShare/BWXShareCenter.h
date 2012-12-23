//
//  BWXShareCenter.h
//  BWXUIKit
//
//  Created by Daly on 12-10-24.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#define BWXShareCenterInstance [BWXShareCenter defaultCenter]

#import <Foundation/Foundation.h>
#import "BWXShareBaseService.h"




@interface BWXShareCenter : NSObject <BWXShareBaseServiceDelegate>
@property (nonatomic,assign)id<BWXShareBaseServiceDelegate> delegate;


/*
 * 描述:设置支持的服务类型
 * serviceTypes = [NSArray arrayWithObjects:[NSNumber numberWithInt:BWXShareTypeSinaWeibo],[NSNumber numberWithInt:BWXShareTypeTencentWeibo],nil];
 * 注:
 * 如果不设置，将会显示全部的服务类型。
 * 如果设置，将会按照数组顺序显示类型。
 */
@property (nonatomic,copy) NSArray *serviceTypes;

/* 描述:分享中心单例*/
+ (BWXShareCenter*)defaultCenter;
/*
 * 描述:分享文本(图片)等
 * @param       imageArr    图片组，不应超过5个UIImage对象
 * @param       aContent    文本内容
 * @param       controller  分享所属controller
 */
- (void)singleShareImage:(NSArray*)imageArr content:(NSString*)aContent withController:(UIViewController *) controller;
/*
 * 描述:分享设置界面
 */
- (UIViewController *) settingViewController;


@end
