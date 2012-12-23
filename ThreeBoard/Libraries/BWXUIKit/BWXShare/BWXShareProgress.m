//
//  BWXShareProgress.m
//  BWXUIKit
//
//  Created by easy on 12-10-26.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "BWXShareProgress.h"
#import "MBProgressHUD.h"

@interface BWXShareProgress () <MBProgressHUDDelegate> {
    MBProgressHUD *_progressHUD;
    NSTimer *_hidTimer;
    BOOL _show;
}

@property (nonatomic, retain) MBProgressHUD *progressHUD;
@end
@implementation BWXShareProgress
@synthesize progressHUD = _progressHUD;
+(id) shareProgress {
    static dispatch_once_t predicate;
	static id instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}

- (void)dealloc
{
    [_hidTimer invalidate];
    [_hidTimer release],_hidTimer = nil;
    [_progressHUD release],_progressHUD = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        if (window == nil) {
            window = [[UIApplication sharedApplication] keyWindow];
        }
    
        _progressHUD = [[MBProgressHUD alloc] initWithWindow:window];
        _progressHUD.removeFromSuperViewOnHide = NO;
        _progressHUD.userInteractionEnabled = NO;
        _progressHUD.minShowTime = 1;
        
        [window addSubview:_progressHUD];
        [window bringSubviewToFront:_progressHUD];
    }
    return self;
}
- (void) doShowLoadingWithMessage:(NSString *) message {
    _progressHUD.mode = MBProgressHUDModeIndeterminate;
    _progressHUD.labelText = message;

    if (!_show) {
        _show = YES;
        [_progressHUD show:YES];
    }
}
- (void) showLoadingWithMessage:(NSString *) message {
    [self performSelectorOnMainThread:@selector(doShowLoadingWithMessage:) withObject:message waitUntilDone:[NSThread isMainThread]];
}

-(void) doShowMessage:(NSString *) message {

    _progressHUD.mode = MBProgressHUDModeCustomView;
    _progressHUD.customView = [[[UIImageView alloc] initWithImage:BWXPNGImage(@"image-tips-smile", @"BWXShare.bundle")] autorelease];
    _progressHUD.labelText = message;
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    if (!_show) {
        _show = YES;
         [_progressHUD show:YES];
    } 
    if(_hidTimer != nil) {
        [_hidTimer setFireDate:fireDate];
    } else {
        _hidTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1 target:self selector:@selector(hideHUD:) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:_hidTimer forMode:NSDefaultRunLoopMode];
    }
}
- (void) showMessage:(NSString *) message {
    [self performSelectorOnMainThread:@selector(doShowMessage:) withObject:message waitUntilDone:[NSThread isMainThread]];
}
-(void) hideHUD:(NSTimer *) timer {
    [self hide];
}

- (void) hide {
    if ([_hidTimer isValid]) {
        [_hidTimer invalidate];
        [_hidTimer release];
        _hidTimer = nil;
    }
    if (_show) {
        [_progressHUD hide:YES];
        _show = NO;
    }
}
@end
