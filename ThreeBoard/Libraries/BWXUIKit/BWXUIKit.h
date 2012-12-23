//
//  BWXUIKit.h
//  BWXUIKit
//
//  Created by Daly on 12-9-26.
//  Copyright (c) 2012年 baidu. All rights reserved.
//



#import <UIKit/UIKit.h>
#define BWXBundlePath(X) [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: (X)]
#define BWXResourcePath(X,Y,Z) [[NSBundle bundleWithPath:BWXBundlePath(Z) ] pathForResource:(X) ofType:(Y)]

//load an image same as imageNamed
#define BWXPNGImage(X,Y) [UIImage imageWithContentsOfFile:BWXResourcePath(([NSString stringWithFormat:@"%@@2x", (X)]), @"png",Y)]

//font
#define BWXFontWithSize(S)		[UIFont fontWithName:@"FZLTHJW--GB1-0" size:S]
#define BWXFontLiteWithSize(S)  [UIFont fontWithName:@"STHeitiSC-Light" size:S]

#define BWXSafeRelease(_obj_) [_obj_ release] , _obj_ = nil;


#define IsHorizontal [BWXUIKit isHorizontal]

#define IsIphone5 [BWXUIKit isIphone5]

#define NowScreenHeight [BWXUIKit nowScreenHeight]

#define NowScreenWidth [BWXUIKit nowScreenWidth]

//Notification
#define kScreenRotate @"kScreenRotate"

//Image
#define UIImageNamed(_fileName_)            [UIImage imageNamed:_fileName_]
#define UIImageViewNamed(_fileName_)        [[[UIImageView alloc] initWithImage:UIImageNamed(_fileName_)] autorelease]

//Array
#define ObjectsArray(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]
#define ObjectsMutArray(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]


@interface BWXUIKit : NSObject
/**
 * 判断横屏的静态方法
 */
+ (BOOL)isHorizontal;

/**
 * 判断是否是iphone5
 */
+ (BOOL)isIphone5;

/**
 * 当前屏幕高度
 */
+ (float)nowScreenHeight;

/**
 * 当前屏幕宽度
 */
+ (float)nowScreenWidth;
@end







