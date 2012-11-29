//
//  UUUIHelper.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-29.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUUIHelper.h"

@implementation UUUIHelper

+(UIButton *)createButtonWithFrame:(CGRect)frame normalImageStr:(NSString *)normalImageStr highlightedImageStr:(NSString *)highlightedImageStr target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button addTarget:target action:selector
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:normalImageStr]
            forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImageStr]
            forState:UIControlStateHighlighted];
    return button;
}

+(UIButton *)createButtonWithFrame:(CGRect)frame normalBgImageStr:(NSString *)normalBgImageStr highlightedBgImageStr:(NSString *)highlightedBgImageStr target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button addTarget:target action:selector
     forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:normalBgImageStr]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightedBgImageStr]
                      forState:UIControlStateHighlighted];
    return button;
}


+ (UIButton*)completeButtonItemWith:(NSString*)str position:(CGPoint)point target:(id)target selector:(SEL)selector
{
	UIFont* titleFont = [UIFont boldSystemFontOfSize:12];
	CGSize titleSize = [str sizeWithFont:titleFont];
	
	UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(point.x,point.y,titleSize.width+26,31)];
	btn.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 13);
	[btn setBackgroundImage:[[UIImage imageNamed:@"common_complete_normal.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15] forState:UIControlStateNormal];
	[btn setBackgroundImage:[[UIImage imageNamed:@"common_complete_press.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15] forState:UIControlStateHighlighted];
	btn.titleLabel.font = titleFont;
	[btn setTitle:str forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	[btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

+ (UIButton*)cancelBlackButtonItemWith:(NSString*)str position:(CGPoint)point target:(id)target selector:(SEL)selector
{
    UIFont* titleFont = [UIFont boldSystemFontOfSize:12];
	CGSize titleSize = [str sizeWithFont:titleFont];
	
	UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(point.x,point.y,titleSize.width+26,31)];
	btn.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 13);
	[btn setBackgroundImage:[[UIImage imageNamed:@"common_cancel_black_normal.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15] forState:UIControlStateNormal];
	[btn setBackgroundImage:[[UIImage imageNamed:@"common_cancel_black_press.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15] forState:UIControlStateHighlighted];
	btn.titleLabel.font = titleFont;
	[btn setTitle:str forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	[btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	return btn;
}

+ (UIBarButtonItem *)createBackBarItem:(id)target action:(SEL)selector
                                 title:(NSString *)title
{
    UIButton* btn;
    UIFont* titleFont = [UIFont boldSystemFontOfSize:12];
    NSString* buttonTitle = title;
    
    CGSize titleSize = [buttonTitle sizeWithFont:titleFont];
    if (titleSize.width > 100) {
        titleSize.width = 100;
    } else if (titleSize.width < 30) {
        titleSize.width = 30;
    }
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,titleSize.width+25,31)];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 1, 9);
    [btn setBackgroundImage:[[UIImage imageNamed:@"common_return_normal.png"] stretchableImageWithLeftCapWidth:15
                                                                                                  topCapHeight:15] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[[UIImage imageNamed:@"common_return_press.png"] stretchableImageWithLeftCapWidth:15
                                                                                                 topCapHeight:15] forState:UIControlStateHighlighted];
    btn.titleLabel.font = titleFont;
    [btn setTitle:buttonTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return backButton;
}


@end
