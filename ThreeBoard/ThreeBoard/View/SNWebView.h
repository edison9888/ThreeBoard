//
//  SNWebView.h
//  SmartN
//
//  Created by lfli on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SNWebView : UIView<UIWebViewDelegate>


@property(nonatomic, strong) UIWebView* webView;

@property(nonatomic, strong) NSString* news;
@property(nonatomic, strong) NSMutableArray* imageArray;

- (void)notifyNews:(NSString*)jsonNews;        //set content to webview

- (void)notifyImages:(NSString*)imageArray;    //set image to webview


@end
