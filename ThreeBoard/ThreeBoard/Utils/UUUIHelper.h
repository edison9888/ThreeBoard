//
//  UUUIHelper.h
//  ThreeBoard
//
//  Created by garyliu on 12-11-29.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UUUIHelper : NSObject

+(UIButton *)createButtonWithFrame:(CGRect)frame normalImageStr:(NSString *)normalImageStr highlightedImageStr:(NSString *)highlightedImageStr target:(id)target selector:(SEL)selector;

+(UIButton *)createButtonWithFrame:(CGRect)frame normalBgImageStr:(NSString *)normalBgImageStr highlightedBgImageStr:(NSString *)highlightedBgImageStr target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem*)createNormalBarButtonItemWithTitle:(NSString*)str position:(CGPoint)point target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem *)createBackBarItem:(id)target action:(SEL)selector
                                 title:(NSString *)title;

+(void)setToolbarBackWithImageStr:(NSString*)backgroundImageStr toolbar:(UIToolbar*)toolbar;

+ (void)setToolbarBackWithImage:(UIImage *)backgroundImage toolbar:(UIToolbar*)toolbar;

@end
