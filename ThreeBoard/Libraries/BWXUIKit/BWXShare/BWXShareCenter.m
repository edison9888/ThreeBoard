//
//  BWXShareCenter.m
//  BWXUIKit
//
//  Created by Daly on 12-10-24.
//  Copyright (c) 2012年 baidu. All rights reserved.
//


#import "BWXShareCenter.h"
#import "BWXShareActionSheet.h"
#import "BWXShareViewController.h"
#import "BWXShareSettingViewController.h"
#import "BWXShareProgress.h"

@interface BWXShareCenter () <BWXShareActionSheetDelegate> {
    BOOL isActiveSharePage;
    BWXShareBaseService *_currentService;
    
    BWXShareViewController *_currentViewController;
    
    NSArray *_serviceTypes;
}

@property(nonatomic,copy)NSArray *imageArray;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)UIViewController *rootViewControllerRef;
@end

@implementation BWXShareCenter
@synthesize content,imageArray;
@synthesize rootViewControllerRef;
@synthesize delegate;
@synthesize serviceTypes = _serviceTypes;
+ (BWXShareCenter*)defaultCenter
{
	static dispatch_once_t predicate;
	static BWXShareCenter *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}
- (id)init
{
    self = [super init];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginPageClosed) name:kLoginPageClosed object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObject:self];
    [_currentService release],_currentService = nil;
    [_currentViewController release],_currentViewController = nil;
    self.content = nil;
    self.imageArray = nil;
    self.rootViewControllerRef = nil;
    self.delegate = nil;
    [super dealloc];
}

- (void)singleShareImage:(NSArray*)imageArr content:(NSString*)aContent withController:(UIViewController *) controller {
    BWXShareActionSheet *actionView = nil;
    if (_serviceTypes) {
        actionView =    [[[BWXShareActionSheet alloc] initWithServiceTypes:_serviceTypes] autorelease];
    } else {
        actionView =    [[[BWXShareActionSheet alloc] init] autorelease];
    }

    actionView.delegate = self;
    self.rootViewControllerRef = controller;
    self.imageArray = imageArr;
    self.content = aContent;
    [actionView show];
}


- (UIViewController *) settingViewController {
    if (_serviceTypes) {
        return [[[BWXShareSettingViewController alloc] initWithServiceTypes:_serviceTypes] autorelease];
    } else {
        return [[[BWXShareSettingViewController alloc] init] autorelease];
    }
}


- (void)loginSuccess:(BWXShareBaseService*)service
{
    if (isActiveSharePage) [self activeSharePage:service];
    
    isActiveSharePage = NO;
    
    if([self.delegate respondsToSelector:@selector(loginSuccess:)])
    {
        [self.delegate loginSuccess:service];
        
    }
}

- (void)loginFail:(BWXShareBaseService*)service error:(NSError*)error
{
    if([delegate respondsToSelector:@selector(loginFail:error:)]) {
        [delegate loginFail:service error:error];
    }

    [[BWXShareProgress shareProgress] showMessage:@"登陆失败"];
    isActiveSharePage = NO;
}

- (void)logoutSuccess:(BWXShareBaseService*)service
{
    if([self.delegate respondsToSelector:@selector(logoutSuccess:)])
    {
        [self.delegate logoutSuccess:service];
    }
    [[BWXShareProgress shareProgress] showMessage:@"注销成功"];
}
- (void)logoutFail:(BWXShareBaseService*)service error:(NSError*)error
{

    //do nothing!

}

- (void)shareSuccess:(BWXShareBaseService*)service
{
    if ([self.delegate respondsToSelector:@selector(shareSuccess:)]) {
        [self.delegate shareSuccess:service];
    }
    //    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
//    [alertView show];
    [[BWXShareProgress shareProgress] showMessage:@"分享成功"];

//    [self.navigationControllerRef popViewControllerAnimated:YES];
    if (_currentViewController) {
        [_currentViewController dismissModalViewControllerAnimated:YES];
        _currentViewController = nil;
    }
}

- (void)shareFail:(BWXShareBaseService*)service error:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(shareFail:error:)]) {
        [self.delegate shareFail:service error:error];
    }
    //    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
//    [alertView show];
    
    [[BWXShareProgress shareProgress] showMessage:@"分享失败"];
}




- (void)activeSharePage:(BWXShareBaseService*)service
{
    BWXShareViewController *controller = [[[BWXShareViewController alloc] init] autorelease];
    controller.service = service;
    controller.content = self.content;
    controller.images = self.imageArray;
    UUNavigationController *nav = [[[UUNavigationController alloc] initWithRootViewController:controller] autorelease];
    [self.rootViewControllerRef presentModalViewController:nav animated:YES];
    _currentViewController = controller;
}

-(void)shareActionSheet:(BWXShareActionSheet *)actionSheet didSelectShareService:(BWXShareBaseService *)service{
    [_currentService release],_currentService = nil;
    _currentService = [service retain];
    _currentService.delegate = self;
    _currentService.rootViewController = self.rootViewControllerRef;
    if ([_currentService isLoggedIn]) {
        [self activeSharePage:_currentService];
    } else {
        isActiveSharePage = YES;
        [_currentService login];
    }
}

- (void)loginPageClosed
{
    isActiveSharePage = NO;
}
@end
