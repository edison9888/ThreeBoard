//
//  BWXShareAuthWebView.m
//  CoreShare
//
//  Created by Daly on 12-11-27.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "BWXShareAuthWebView.h"
#import "BWXUIKitBase.h"


@interface BWXShareAuthWebView ()
{
}

@end


@implementation BWXShareAuthWebView
@synthesize webView;

- (void)dealloc
{
    self.webView.delegate = nil;
    self.webView = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, NowScreenHeight*2, NowScreenWidth, NowScreenHeight)];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 44,NowScreenWidth, NowScreenHeight - 20)] autorelease];
        self.webView.delegate = self;
        [self addSubview:webView];
        
         UIImage *imgBgNav = [[UIImage imageNamed:@"navigationbar_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 4, 10, 4)];
//        UIImage* imgBgNav =  BWXPNGImage(@"bg_nav", @"BWXBase.bundle");
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NowScreenWidth, 44)];
        headerView.backgroundColor = [UIColor colorWithPatternImage:imgBgNav];
        [self addSubview:headerView];
        [headerView release];
        
        UIImage* imgBgNavBtn =  [[UIImage imageNamed:@"navigationbar_btn.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15];
        UIImage* imgBgNavBtn_select =  [[UIImage imageNamed:@"navigationbar_btn_press.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15];
        
        UIButton *btn_colse = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_colse setFrame:CGRectMake(12, 5 ,55, 33)];
        btn_colse.titleLabel.font = BWXFontWithSize(13);
        btn_colse.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [btn_colse setTitle:@"关闭" forState:UIControlStateNormal];
        [btn_colse setBackgroundImage:imgBgNavBtn forState:UIControlStateNormal];
        [btn_colse setBackgroundImage:imgBgNavBtn_select forState:UIControlStateHighlighted];
        [btn_colse addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn_colse];
        

    }
    return self;
}

- (void)show
{
    self.frame = CGRectMake(self.frame.origin.x, NowScreenHeight*2, self.frame.size.width, self.frame.size.height);

    [[UIApplication sharedApplication].keyWindow addSubview:self];

    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showLoginViewAnimationStop)];
    
    self.frame = CGRectMake(self.frame.origin.x, 20, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];

}

- (void)showLoginViewAnimationStop
{
    
    
}


- (void)hide
{
    [self endEditing:YES];
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideLoginViewAnimationStop)];
    self.frame = CGRectMake(self.frame.origin.x, NowScreenHeight*2, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    
}

- (void)hideLoginViewAnimationStop
{
    [self removeFromSuperview];

}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
