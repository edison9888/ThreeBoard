//
//  UIWebView+FinishLoad.m
//  TravianBot
//
//  Created by Roman Gardukevich on 9/3/12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import "UIWebView+FinishLoad.h"
#import <objc/runtime.h>

@interface UIWebViewCompleteHandlerWrapper: NSObject<UIWebViewDelegate>
@property (nonatomic, copy) void (^blockAddition)(BOOL success);

-(void)invokeBlock:(BOOL)success;
@end

@implementation UIWebViewCompleteHandlerWrapper
@synthesize blockAddition;

-(void)dealloc{
    self.blockAddition = nil;
    [super dealloc];
}

-(void)invokeBlock:(BOOL)success{
    if (blockAddition) {        
        [self blockAddition](success);
        self.blockAddition = nil;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self invokeBlock:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self invokeBlock:NO];
}

@end

static const char* UIWebViewBlocksArrayKey = "UIWebViewBlocksArrayKey";

@implementation UIWebView (FinishLoad)

-(void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL withBlock:(void (^)(BOOL))block
{
//    [block copy];
    NSMutableArray* blockActions = objc_getAssociatedObject(self, &UIWebViewBlocksArrayKey);
    if (blockActions == nil) {
        blockActions = [NSMutableArray array];
        objc_setAssociatedObject(self, &UIWebViewBlocksArrayKey, blockActions, OBJC_ASSOCIATION_RETAIN);
    }
    
    UIWebViewCompleteHandlerWrapper* wrapper = [[UIWebViewCompleteHandlerWrapper alloc] init];
    [wrapper setBlockAddition:block];
    [blockActions addObject:wrapper];
    
    self.delegate = wrapper;
    [self loadHTMLString:string baseURL:baseURL];
    [wrapper release];
}

@end
