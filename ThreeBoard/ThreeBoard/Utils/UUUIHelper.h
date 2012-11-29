//
//  UUUIHelper.h
//  ThreeBoard
//
//  Created by garyliu on 12-11-29.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UU_BG_SLATE_GRAY     [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]


@interface UUUIHelper : NSObject

+(UIButton *)createButtonWithFrame:(CGRect)frame normalImageStr:(NSString *)normalImageStr highlightedImageStr:(NSString *)highlightedImageStr target:(id)target selector:(SEL)selector;

+(UIButton *)createButtonWithFrame:(CGRect)frame normalBgImageStr:(NSString *)normalBgImageStr highlightedBgImageStr:(NSString *)highlightedBgImageStr target:(id)target selector:(SEL)selector;

+ (UIButton*)completeButtonItemWith:(NSString*)str position:(CGPoint)point target:(id)target selector:(SEL)selector;

+ (UIButton*)cancelBlackButtonItemWith:(NSString*)str position:(CGPoint)point target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem *)createBackBarItem:(id)target action:(SEL)selector
                                 title:(NSString *)title;
@end
