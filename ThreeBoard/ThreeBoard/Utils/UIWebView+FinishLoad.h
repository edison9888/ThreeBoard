//
//  UIWebView+FinishLoad.h
//  TravianBot
//
//  Created by Roman Gardukevich on 9/3/12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (FinishLoad)
-(void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL withBlock:(void (^)(BOOL success))block;
@end
