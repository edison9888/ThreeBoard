//
//  UUUIHelper.h
//  ThreeBoard
//
//  Created by garyliu on 12-11-29.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCommonHighHeight       60
#define kCommonLowHeight        50
#define kCommonSectionHeight    24

//#define kTagFocusImageView 1
//#define kTagFocusTitleLabel 2

#define UU_BG_SLATE_GRAY     [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]
#define UU_IMAGEVIEW_BORDER_COLOR [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:0.5f]
#define UU_TEXT_BLACK         [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]
#define UU_DEVIDE_LINE_COLOR  [UIColor colorWithRed:0xda/255.0f green:0xda/255.0f blue:0xda/255.0f alpha:1.0f]
#define UU_TEXT_LIGHT_BLACK   [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f]
#define UU_BG_WHITE          [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1]
#define UU_BG_SLATE_GRAY     [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]
#define UU_BG_DARK_SLATE_GRAY [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]
#define UU_TEXT_GRAY  [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]
#define UU_SELECTED_BLUE      [UIColor colorWithRed:39/255.0f green:156/255.0f blue:231/255.0f alpha:1.0f]
#define UU_TEXT_GRAY_MIDDLE   [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f]
#define UU_TEXT_GRAY_113      [UIColor colorWithRed:113/255.0f green:113/255.0f blue:113/255.0f alpha:1.0f]
#define UU_TEXT_GRAY_DARK     [UIColor colorWithRed:127/255.0f green:127/255.0f blue:127/255.0f alpha:1.0f]

@interface UUUIHelper : NSObject

+(UIButton *)createButtonWithFrame:(CGRect)frame normalImageStr:(NSString *)normalImageStr highlightedImageStr:(NSString *)highlightedImageStr target:(id)target selector:(SEL)selector;

+(UIButton *)createButtonWithFrame:(CGRect)frame normalBgImageStr:(NSString *)normalBgImageStr highlightedBgImageStr:(NSString *)highlightedBgImageStr target:(id)target selector:(SEL)selector;

+ (UIButton*)completeButtonItemWith:(NSString*)str position:(CGPoint)point target:(id)target selector:(SEL)selector;

+ (UIButton*)cancelBlackButtonItemWith:(NSString*)str position:(CGPoint)point target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem *)createBackBarItem:(id)target action:(SEL)selector
                                 title:(NSString *)title;
@end
