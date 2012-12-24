//
//  UIBarHelper.m
//  BWXUIKit
//
//  Created by easy on 12-11-21.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "UIBarHelper.h"

@implementation UIBarHelper

+(UIBarButtonItem *) leftBarButtonItemWithTitle:(NSString *) title font:(UIFont *) font target:(id) target action:(SEL) action {
    CGFloat capWidth = 12.0f;
    
    UIImage *rightNormalImage = [BWXPNGImage(@"bg_navbtn_back_normal",@"BWXBase.bundle") stretchableImageWithLeftCapWidth:capWidth topCapHeight:0];
    UIImage *rightSelectImage = [BWXPNGImage(@"bg_navbtn_back_select",@"BWXBase.bundle") stretchableImageWithLeftCapWidth:capWidth topCapHeight:0];
    
    CGSize titleSize;
    if ([title length] > 0 && font > 0) {
        CGSize fontSize = [title sizeWithFont:font];
        CGFloat titleWidth = fontSize.width+capWidth * 2 < rightNormalImage.size.width ? rightNormalImage.size.width : fontSize.width+capWidth * 2;
        titleSize = CGSizeMake(titleWidth, rightNormalImage.size.height);
    } else {
        titleSize = rightNormalImage.size;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:rightNormalImage forState:UIControlStateNormal];
    [button setBackgroundImage:rightSelectImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, capWidth, 0, capWidth/2)];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    button.titleLabel.font = font;
    
    button.frame = CGRectMake(0, 0, titleSize.width,titleSize.height);
    
    if (target != nil && action != NULL) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+(UIBarButtonItem *) rightBarButtonItemWithTitle:(NSString *) title font:(UIFont *) font target:(id) target action:(SEL) action{
    
    CGFloat capWidth = 10.0f;
    
    UIImage *rightNormalImage = [BWXPNGImage(@"bg_navbtn_normal",@"BWXBase.bundle") stretchableImageWithLeftCapWidth:capWidth topCapHeight:0];
    UIImage *rightSelectImage = [BWXPNGImage(@"bg_navbtn_select",@"BWXBase.bundle") stretchableImageWithLeftCapWidth:capWidth topCapHeight:0];
    
    CGSize titleSize;
    if ([title length] > 0 && font > 0) {
        CGSize fontSize = [title sizeWithFont:font];
        CGFloat titleWidth = fontSize.width+capWidth * 2 < rightNormalImage.size.width ? rightNormalImage.size.width : fontSize.width+capWidth * 2;
        titleSize = CGSizeMake(titleWidth, rightNormalImage.size.height);
    } else {
        titleSize = rightNormalImage.size;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:rightNormalImage forState:UIControlStateNormal];
    [button setBackgroundImage:rightSelectImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.frame = CGRectMake(0, 0, titleSize.width,titleSize.height);
    
    if (target != nil && action != NULL) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}


+ (UIBarButtonItem*)createNormalBarButtonItemWithTitle:(NSString*)str position:(CGPoint)point target:(id)target selector:(SEL)selector
{
	UIFont* titleFont = [UIFont fontWithName:UU_CUSTOM_BODY_FONT size:12];
	CGSize titleSize = [str sizeWithFont:titleFont];
	
	UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(point.x,point.y,titleSize.width+26,31)];
	btn.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 13);
	[btn setBackgroundImage:[[UIImage imageNamed:@"navigationbar_btn.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15] forState:UIControlStateNormal];
	[btn setBackgroundImage:[[UIImage imageNamed:@"navigationbar_btn_press.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15] forState:UIControlStateHighlighted];
	btn.titleLabel.font = titleFont;
	[btn setTitle:str forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	[btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    [btn release];
    
	return barButtonItem;
}

+(UILabel *) titleLabelWithTitle:(NSString *) title font:(UIFont *) font {
    CGSize size = [title sizeWithFont:font];
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
    if ([title length] > 0) {
        titleLabel.text = title;
    }
    titleLabel.textAlignment = UITextAlignmentCenter;
    
    if (font != nil) {
        titleLabel.font = font;
    }
    
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    return titleLabel;
}

@end
