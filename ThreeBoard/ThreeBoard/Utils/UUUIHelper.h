//
//  UUUIHelper.h
//  ThreeBoard
//
//  Created by garyliu on 12-11-29.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLyricHeight            66
#define kCommonHighHeight       60
#define kCommonLowHeight        50
#define kCommonSectionHeight    26
#define kCommonSectionLabelX    10
#define UU_BG_SLATE_GRAY     [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]
#define kImageViewOffsetX   3
#define kImageViewOffsetY   3
#define kTextLabelOffset    10
#define kImageViewWidth     54
#define kImageViewHeight    54
#define kImageViewRadius    5
#define kImageViewBorderWidth   1
#define TING_IMAGEVIEW_BORDER_COLOR [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:0.5f]
#define TING_TEXT_BLACK         [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]
#define TING_DEVIDE_LINE_COLOR  [UIColor colorWithRed:0xda/255.0f green:0xda/255.0f blue:0xda/255.0f alpha:1.0f]
#define TING_TEXT_LIGHT_BLACK   [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f]
#define TING_BG_WHITE          [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1]
#define TING_BG_SLATE_GRAY     [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]



@interface UUUIHelper : NSObject

+(UIButton *)createButtonWithFrame:(CGRect)frame normalImageStr:(NSString *)normalImageStr highlightedImageStr:(NSString *)highlightedImageStr target:(id)target selector:(SEL)selector;

+(UIButton *)createButtonWithFrame:(CGRect)frame normalBgImageStr:(NSString *)normalBgImageStr highlightedBgImageStr:(NSString *)highlightedBgImageStr target:(id)target selector:(SEL)selector;

+ (UIButton*)completeButtonItemWith:(NSString*)str position:(CGPoint)point target:(id)target selector:(SEL)selector;

+ (UIButton*)cancelBlackButtonItemWith:(NSString*)str position:(CGPoint)point target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem *)createBackBarItem:(id)target action:(SEL)selector
                                 title:(NSString *)title;
@end
