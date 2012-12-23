//
//  BWXShareAuthWebView.h
//  CoreShare
//
//  Created by Daly on 12-11-27.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BWXShareAuthWebView : UIView <UIWebViewDelegate>
@property(nonatomic,retain)UIWebView *webView;

- (void)show;
- (void)hide;
@end
