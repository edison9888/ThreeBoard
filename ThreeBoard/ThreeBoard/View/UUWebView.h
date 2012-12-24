//
//  SNWebView.h
//  SmartN
//
//  Created by lfli on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUWebView;
@protocol UUWebViewDelegate <NSObject>

- (void)webViewDidFinishLoad:(UUWebView *)webView;
- (void)webView:(UUWebView *)webView didFailLoadWithError:(NSError *)error;

@end


@interface UUWebView : UIView<UIWebViewDelegate>


@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) NSString* news;
@property (nonatomic, strong) NSMutableArray* imageArray;
@property (nonatomic, weak) id<UUWebViewDelegate> delegate;

- (void)notifyNews:(NSString*)jsonNews;        //set content to webview

- (void)notifyImages:(NSString*)imageArray;    //set image to webview


@end
