//
//  NSString+Javascript.m
//  ttt
//
//  Created by Roman Gardukevich on 9/4/12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import "NSString+Javascript.h"
#import "UIWebView+FinishLoad.h"

@implementation NSString (Javascript)

-(NSString *)runJavascript:(NSString *)js
{
    UIWebView* webView = [[UIWebView alloc] init];
    
    __block NSString* result = nil;
    
    __block BOOL blockFinished = NO;
    
    
    [webView loadHTMLString:self baseURL:nil withBlock:^(BOOL success) {
        blockFinished = YES;
        result = [[webView stringByEvaluatingJavaScriptFromString:js] retain];
    }];
    
    while (!blockFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [webView release];
    return result;
}



@end
