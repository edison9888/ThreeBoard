//
//  UIBarHelper.h
//  BWXUIKit
//
//  Created by easy on 12-11-21.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWXUIKit.h"

@interface UIBarHelper : NSObject
+(UIBarButtonItem *) leftBarButtonItemWithTitle:(NSString *) title font:(UIFont *) font target:(id) target action:(SEL) action;
+(UIBarButtonItem *) rightBarButtonItemWithTitle:(NSString *) title font:(UIFont *) font target:(id) target action:(SEL) action;
+(UILabel *) titleLabelWithTitle:(NSString *) title font:(UIFont *) font;
@end
