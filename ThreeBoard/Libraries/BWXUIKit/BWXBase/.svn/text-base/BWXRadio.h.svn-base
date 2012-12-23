//
//  BWXRadio.h
//  BWXUIKit
//
//  Created by easy on 12-11-2.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BWXRadio : UIControl
/*描述:设置是否选中*/
@property(nonatomic,getter=isOn) BOOL on;//kvo or UIControlEventValueChanged
/*
 * 描述:控件所在组
 *     该组为全局组，当组对象为同一对象时，即代表属于一个组
 *     当组内的某一radio选中时，其它radio将取消选中
 */
@property(nonatomic,retain) id group;//global group name

- (id)initWithFrame:(CGRect)frame;
@end