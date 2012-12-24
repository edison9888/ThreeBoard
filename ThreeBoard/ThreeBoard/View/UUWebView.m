//
//  SNWebView.m
//  SmartN
//
//  Created by lfli on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UUWebView.h"
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"



@interface UUWebView()
{

}

- (void)loadWebView;
- (void)initlization;
- (NSString *)htmlEntityDecode:(NSString *)string;

@end

@implementation UUWebView

@synthesize news;
@synthesize imageArray;
@synthesize webView;
@synthesize delegate;

- (id)init
{
    if(self = [super init]){
        [self initlization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{   
    if(self = [super initWithFrame:frame]){
        
        [self initlization];
    }
    return self; 
}


#pragma mark - public methods

- (void)notifyNews:(NSString*)jsonNews
{
    DDLogInfo(@"notifynews %f",[[NSDate date] timeIntervalSince1970]);
    
    NSString* strFormat = [NSString stringWithFormat:@"setViewMode(%d)", 1];
    [self.webView stringByEvaluatingJavaScriptFromString:strFormat];
    
    strFormat = [NSString stringWithFormat:@"setTextFont(%d)", 2];
    [self.webView stringByEvaluatingJavaScriptFromString:strFormat];

    NSString *str = [NSString stringWithFormat:@"setContent(%@)", jsonNews];
    [self.webView stringByEvaluatingJavaScriptFromString:str];
    
}

- (void)notifyImages:(NSString*)_imageArray
{
    
    if (nil == _imageArray) {
        return;
    }
    
    NSString* strFormat = [NSString stringWithFormat:@"setImage(%@)", _imageArray];
    strFormat = [self htmlEntityDecode:strFormat];
    [self.webView stringByEvaluatingJavaScriptFromString:strFormat];

}

#pragma mark - private methods

- (void)initlization
{
    self.backgroundColor = UU_BG_WHITE;
    
    self.news = @"";
    self.imageArray = [NSMutableArray arrayWithCapacity:4];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.bounds];
    self.webView.backgroundColor = [UIColor clearColor];
    webView.scalesPageToFit = YES;
    webView.contentMode = UIViewContentModeScaleAspectFit;
    webView.delegate = self;
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self addSubview:webView];
    
    UIScrollView* scrollView = nil;
    for (UIView *subView in [webView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView*)subView;
            scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
            break;
        }
    }
    
    [self loadWebView];
    
}

- (void)loadWebView{
    
    //    NSString* filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"smartnews.html"];
    //    NSURL* url = [NSURL fileURLWithPath:filePath];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"uu" ofType:@"html"]isDirectory:NO];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

-(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    return string;
}

#pragma mark - WebView delegate methods

- (void)webViewDidFinishLoad:(UIWebView *)_webView
{
    DDLogInfo(@"webViewDidFinishLoad %f",[[NSDate date] timeIntervalSince1970]);
    if([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]){
        [self.delegate webViewDidFinishLoad:self];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DDLogInfo(@"didFailLoadWithError %f",[[NSDate date] timeIntervalSince1970]);
    DDLogInfo(@"%@\n%@",[error localizedDescription], [error localizedFailureReason]);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSString* urlString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlString = [self htmlEntityDecode:urlString];
    if([urlString hasPrefix:@"uu://"]){
        return NO;
    }
    return YES;
}


@end
