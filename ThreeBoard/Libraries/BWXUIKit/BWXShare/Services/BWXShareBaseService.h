//
//  BWXShareBaseService.h
//  BWXUIKit
//
//  Created by Daly on 12-10-23.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#define BWXShareServiceCenterInstance [BWXShareServiceCenter sharedInstance]

typedef enum {
    BWXShareTypeSinaWeibo,
    BWXShareTypeTencentWeibo,
    BWXShareTypeRenren,
    BWXShareTypeQZone,
    BWXShareTypeWeixinSession,
    BWXShareTypeWeixinTimeline,
    BWXShareTypeTwitter = NSIntegerMax - 2,
    BWXShareTypeFacebook = NSIntegerMax - 1,
} BWXShareType;



#import <Foundation/Foundation.h>
#import "BWXShareBaseService.h"
#import "BWXShareRequest.h"

@class BWXShareBaseService;
@class BWXShareUserModel;
@protocol BWXShareBaseServiceDelegate <NSObject>

@optional

/**
 * 描述:登陆成功回调
 *
 * @param        service     分享服务类对象
 *
 */
- (void)loginSuccess:(BWXShareBaseService*)service;


/**
 * 描述:登陆失败回调
 *
 * @param        service     分享服务类对象
 * @param        error       返回错误
 *
 */
- (void)loginFail:(BWXShareBaseService*)service error:(NSError*)error;

/**
 * 描述:登出成功回调
 *
 * @param        service     分享服务类对象
 *
 */
- (void)logoutSuccess:(BWXShareBaseService*)service;

/**
 * 描述:登出失败回调
 *
 * @param        service     分享服务类对象
 * @param        error       返回错误
 *
 */
- (void)logoutFail:(BWXShareBaseService*)service error:(NSError*)error;

/**
 * 描述:分享成功回调
 *
 * @param        service     分享服务类对象
 *
 */
- (void)shareSuccess:(BWXShareBaseService*)service;

/**
 * 描述:分享失败回调
 *
 * @param        service     分享服务类对象
 * @param        error       返回错误
 *
 */
- (void)shareFail:(BWXShareBaseService*)service error:(NSError*)error;

@end




@interface BWXShareBaseService : NSObject
{
    NSString *appKey;
    NSString *appSecret;
    NSString *redirectURI;
    NSString *_accessToken;
    NSTimeInterval _expireTime;
    BWXShareUserModel *_user;
    
}
@property(nonatomic,readonly)NSString *accessToken;
@property(nonatomic,readonly)NSTimeInterval expireTime;
@property(nonatomic,readonly)BWXShareUserModel *user;

/**
 * 描述:服务类委托
 */
@property (nonatomic,assign)id<BWXShareBaseServiceDelegate> delegate;

/**
 * 描述:用于支撑登陆web页面的viewController
 */
@property(nonatomic,assign)UIViewController *rootViewController;

/**
 * 描述:分享类型名称
 */
@property(nonatomic,retain)NSString *typeName;

/**
 * 描述:sns Type
 */
@property(nonatomic)BWXShareType type;


/**
 * 描述:是否过期
 */
- (BOOL)IsExpired;
/**
 * 描述:获取服务类的单例对象
 */
//+ (id)sharedInstance;

/**
 * 描述:登录
 */
- (void)login;

/**
 * 描述:登出
 */
- (void)logout;

/**
 * 描述:判断是否已经登陆
 */
- (BOOL)isLoggedIn;

/**
 * 描述:分享图片
 */
- (void)shareImage:(UIImage*)image withText:(NSString*)text;

@end



@interface BWXShareBaseServiceFactory : NSObject
+ (id)sharedInstance;
+ (BWXShareBaseService*)makeShareServiceByType:(BWXShareType)type;

@end


