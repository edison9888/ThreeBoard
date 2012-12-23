//
//  BWXShareBaseService.m
//  BWXUIKit
//
//  Created by Daly on 12-10-23.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "BWXShareBaseService.h"
#import "BWXShareBaseService.h"


@interface BWXShareBaseService ()
{


}
@end

@implementation BWXShareBaseService
@synthesize delegate;
@synthesize rootViewController;
@synthesize typeName;
@synthesize accessToken = _accessToken;
@synthesize expireTime = _expireTime;
@synthesize user = _user;
@synthesize type;

- (void)dealloc
{
    self.delegate = nil;
    self.rootViewController = nil;
    [appKey release]; appKey = nil;
    [appSecret release]; appSecret = nil;
    [redirectURI release]; redirectURI = nil;
    [_accessToken release]; _accessToken = nil;
    [_user release]; _user = nil;
    self.typeName = nil;
    [super dealloc];
}

+ (id)sharedInstance
{
    NSAssert(NO, @"this must implement by subclass");
    return nil;
}

- (void)login
{
    NSAssert(NO, @"this must implement by subclass");
}

- (BOOL)isLoggedIn
{
    NSAssert(NO, @"this must implement by subclass");
    return NO;
}

- (void)logout
{
    NSAssert(NO, @"this must implement by subclass");
}

- (void)shareImage:(UIImage*)image withText:(NSString*)text
{
    NSAssert(NO, @"this must implement by subclass");
}

- (BOOL)IsExpired
{
    NSAssert(NO, @"this must implement by subclass");
    return YES;
}

@end




#import "BWXShareSinaWeiboService.h"
#import "BWXShareTencentWeiboService.h"
#import "BWXShareRenrenService.h"
#import "BWXShareQZoneService.h"
#import "BWXShareWeixinService.h"

@interface BWXShareBaseServiceFactory ()



@end


@implementation BWXShareBaseServiceFactory
+ (id)sharedInstance
{
    
	static dispatch_once_t predicate;
    static BWXShareBaseServiceFactory *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}



+ (BWXShareBaseService*)makeShareServiceByType:(BWXShareType)type
{
    BWXShareBaseService *service = nil;
    switch (type) {
        case BWXShareTypeSinaWeibo:
            service =  [[BWXShareSinaWeiboService alloc] init];
            break;
        case BWXShareTypeTencentWeibo:
            service =  [[BWXShareTencentWeiboService alloc] init];
            break;
        case BWXShareTypeRenren:
            service =  [[BWXShareRenrenService alloc] init];
            break;
        case BWXShareTypeQZone:
            service = [[BWXShareQZoneService alloc] init];
            break;
        case BWXShareTypeWeixinSession:
            service = [[BWXShareWeixinService alloc] initWithWeixinType:BWXShareWeixinServiceTypeDefault];
            break;
        case BWXShareTypeWeixinTimeline:
            service = [[BWXShareWeixinService alloc] initWithWeixinType:BWXShareWeixinServiceTypeTimeline];
            break;
        default:
            break;
    }
    return [service autorelease];
}
@end



