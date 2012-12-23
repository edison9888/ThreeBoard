//
//  BWXCheckBox.h
//  BWXUIKit
//
//  Created by easy on 12-11-7.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWXCheckBox : UIControl
/*描述:设置是否选中*/
@property (nonatomic, getter = isOn) BOOL on;//kvo or UIControlEventValueChanged

-(id)initWithFrame:(CGRect)frame;
@end
