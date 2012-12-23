//
//  BWXShareQZoneService.m
//  BWXUIKit
//
//  Created by easy on 12-12-7.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "BWXShareQZoneService.h"
#import "SFHFKeychainUtils.h"
#import "BWXShareUserModel.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "BWXShareAuthWebView.h"
#import "JSONKit.h"

#define kBWXQZoneKeychainOpenID @"kBWXQZoneKeychainOpenID"
#define kBWXQZoneKeychainAccessToken @"kBWXQZoneKeychainAccessToken"
#define kBWXQZoneKeychainExpireTime @"kBWXQZoneKeychainExpireTime"
#define kBWXQZoneKeychainServiceNameSuffix    @"kBWXQZoneKeychainServiceNameSuffix"
#define kBWXQZoneKeychainUserID @"kBWXQZoneKeychainUserID"
#define kBWXQZoneKeychainUserName @"kBWXQZoneKeychainUserName"


#define kBWXQZoneGraphBaseURL @"https://graph.qq.com/oauth2.0/"
#define kBWXQZoneBaseURL @"https://graph.qq.com/"
#define kBWXQZoneLogin @"authorize"
#define kBWXQZoneMe @"me"
#define kBWXQZoneGetUserInfo @"get_user_info"
#define kBWXQZoneAddTopic @"add_topic"
#define kBWXQZoneUploadPicture @"upload_pic"
@interface BWXShareQZoneService () {
    ASIHTTPRequest *userInfoRequest;
    ASIHTTPRequest *getAccessTokenRequest;
    ASIFormDataRequest *shareImageRequest;
    ASIHTTPRequest *shareTextRequest;
    BWXShareAuthWebView *webView;
    NSArray *_permissions;
    
    NSString *_openId;
}

@end
@implementation BWXShareQZoneService

- (void)dealloc
{
    
    [shareTextRequest clearDelegatesAndCancel];
    [shareTextRequest release],shareImageRequest = nil;
    [userInfoRequest clearDelegatesAndCancel];
    [userInfoRequest release],userInfoRequest = nil;
    [shareImageRequest clearDelegatesAndCancel];
    [shareImageRequest release],shareImageRequest = nil;
    [getAccessTokenRequest clearDelegatesAndCancel];
    [getAccessTokenRequest release],getAccessTokenRequest = nil;
    webView.webView.delegate = nil;
    [webView release]; webView = nil;
    [_openId release];
    [_permissions release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        appKey = [kBWXQZoneAppKey copy];
//        appSecret = [kBWXQZoneSecretKey copy];
        redirectURI = [kBWXQZoneRedirectUrl copy];
        _user = [[BWXShareUserModel alloc] init];
        _openId = [[SFHFKeychainUtils getPasswordForUsername:kBWXQZoneKeychainOpenID andServiceName:kBWXQZoneKeychainServiceNameSuffix error:nil] copy];
        _accessToken = [[SFHFKeychainUtils getPasswordForUsername:kBWXQZoneKeychainAccessToken andServiceName:kBWXQZoneKeychainServiceNameSuffix error:nil] copy];
        _expireTime = [[SFHFKeychainUtils getPasswordForUsername:kBWXQZoneKeychainExpireTime andServiceName:kBWXQZoneKeychainServiceNameSuffix error:nil] doubleValue];
        _user.userID = [SFHFKeychainUtils getPasswordForUsername:kBWXQZoneKeychainUserID andServiceName:kBWXQZoneKeychainServiceNameSuffix error:nil];
        _user.userName = [SFHFKeychainUtils getPasswordForUsername:kBWXQZoneKeychainUserName andServiceName:kBWXQZoneKeychainServiceNameSuffix error:nil];
        self.typeName = @"QQ空间";
        self.type = BWXShareTypeQZone;
        _permissions = [[NSArray alloc] initWithObjects:kBWXQZoneGetUserInfo, kBWXQZoneAddTopic,kBWXQZoneUploadPicture,nil];
    }
    return self;
}

- (void)deleteAuthorizeDataInKeychain
{
    _user.userID = nil;
    _user.userName = nil;
    _accessToken = nil;
    _expireTime = 0;
    
    [SFHFKeychainUtils deleteItemForUsername:kBWXQZoneKeychainOpenID
                              andServiceName:kBWXQZoneKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kBWXQZoneKeychainAccessToken
                              andServiceName:kBWXQZoneKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kBWXQZoneKeychainExpireTime
                              andServiceName:kBWXQZoneKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kBWXQZoneKeychainUserID
                              andServiceName:kBWXQZoneKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kBWXQZoneKeychainUserName
                              andServiceName:kBWXQZoneKeychainServiceNameSuffix error:nil];
    
}

//- (void)storeAuthorizeDataInKeychain {
//    [SFHFKeychainUtils storeUsername:kBWXQZoneKeychainOpenID andPassword:_openId
//                      forServiceName:kBWXQZoneKeychainServiceNameSuffix updateExisting:YES error:nil];
//    [SFHFKeychainUtils storeUsername:kBWXQZoneKeychainAccessToken andPassword:self.accessToken
//                      forServiceName:kBWXQZoneKeychainServiceNameSuffix updateExisting:YES error:nil];
//    [SFHFKeychainUtils storeUsername:kBWXQZoneKeychainExpireTime andPassword:[NSString stringWithFormat:@"%lf", self.expireTime]
//                      forServiceName:kBWXQZoneKeychainServiceNameSuffix updateExisting:YES error:nil];
//}

- (BOOL)IsExpired
{
    if ([[NSDate date] timeIntervalSince1970] > self.expireTime)
    {
        // force to log out
        [self deleteAuthorizeDataInKeychain];
        return YES;
    }
    return NO;
}

- (void)login {

    
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"token", @"response_type",
                                   appKey, @"client_id",
                                   @"user_agent", @"type",
                                   redirectURI, @"redirect_uri",
                                   @"mobile", @"display",
								   [NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"status_os",
								   [[UIDevice currentDevice] name],@"status_machine",
                                   @"v2.0",@"status_version",
                                   nil];
	
    if ([_permissions count] > 0) {
        NSString *permissionString = [_permissions componentsJoinedByString:@","];
        [params setObject:permissionString forKey:@"scope"];
    }
   
    NSString *url = [kBWXQZoneGraphBaseURL stringByAppendingString:kBWXQZoneLogin];
    NSString *urlString = [BWXShareRequest serializeURL:url
                                                 params:params
                                             httpMethod:@"GET"];
    if (webView)  [webView release];
    
    webView = [[BWXShareAuthWebView alloc] init];
    
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kBWXQZoneBaseURL]];
    
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    webView.webView.delegate = self;
    [webView.webView loadRequest:request];
    [webView show];
}

- (void)logout {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kBWXQZoneBaseURL]];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    [self deleteAuthorizeDataInKeychain];
    
    
    if ([self.delegate respondsToSelector:@selector(logoutSuccess:)])
    {
        [self.delegate logoutSuccess:self];
    }
}

- (BOOL)isLoggedIn {
    return _openId && self.accessToken && ![self IsExpired];
}


/**
 * 描述:分享图片
 */
- (void)shareImage:(UIImage*)image withText:(NSString*)text {
    if (![self isLoggedIn] && [self IsExpired]) {
        
        [self login];
        return;
    }

    if (!image) {
        [shareImageRequest clearDelegatesAndCancel];
        [shareImageRequest release];
        //add_topic
        NSString *url = [NSString stringWithFormat:@"%@shuoshuo/%@",kBWXQZoneBaseURL,kBWXQZoneAddTopic];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                appKey, @"oauth_consumer_key",
                                @"json",@"format",
                                _accessToken,@"access_token",
                                _openId,@"openid",
                                nil];
        NSString *urlString = [BWXShareRequest serializeURL:url
                                                     params:params
                                                 httpMethod:@"GET"];
        
        shareTextRequest = [[ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]] retain];
        shareTextRequest.delegate = self;
        shareTextRequest.didFinishSelector = @selector(didFinishRequest:);
        shareTextRequest.didFailSelector = @selector(didFailRequest:);
        [shareTextRequest startAsynchronous];
    } else {
        [shareImageRequest clearDelegatesAndCancel];
        [shareImageRequest release];
        //upload_pic
        NSString *url = [NSString stringWithFormat:@"%@photo/%@",kBWXQZoneBaseURL,kBWXQZoneUploadPicture];
        shareImageRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]]retain];
        [shareImageRequest setPostValue:appKey forKey:@"oauth_consumer_key"];
        [shareImageRequest setPostValue:_accessToken forKey:@"access_token"];
        [shareImageRequest setPostValue:_openId forKey:@"openid"];
        [shareImageRequest setPostValue:text forKey:@"photodesc"];
        [shareImageRequest setPostValue:@"1" forKey:@"mobile"];
        
        [shareImageRequest setData:UIImagePNGRepresentation(image) withFileName:@"post.jpg" andContentType:@"image/jpeg" forKey:@"picture"];
        
        shareImageRequest.delegate = self;
        shareImageRequest.didFinishSelector = @selector(didFinishRequest:);
        shareImageRequest.didFailSelector = @selector(didFailRequest:);
        shareImageRequest.timeOutSeconds = 120;
        [shareImageRequest startAsynchronous];
        
    }
}





-(void) requestUserInfo{
    [userInfoRequest clearDelegatesAndCancel];
    [userInfoRequest release];
    NSString *url = [NSString stringWithFormat:@"%@user/%@",kBWXQZoneBaseURL,kBWXQZoneGetUserInfo];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            appKey, @"oauth_consumer_key",
                            @"json",@"format",
                            _accessToken,@"access_token",
                            _openId,@"openid",
                            nil];
    NSString *urlString = [BWXShareRequest serializeURL:url
                                                 params:params
                                             httpMethod:@"GET"];
    userInfoRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    userInfoRequest.delegate = self;
    userInfoRequest.didFinishSelector = @selector(didFinishRequest:);
    userInfoRequest.didFailSelector = @selector(didFailRequest:);
    [userInfoRequest startAsynchronous];
}

-(void) requestOpenIdWithAccessToken:(NSString *) token expireTime:(NSTimeInterval) time {
    _expireTime = time;
    [_accessToken release];
    _accessToken = [token copy];
    
    [SFHFKeychainUtils storeUsername:kBWXQZoneKeychainExpireTime andPassword:[NSString stringWithFormat:@"%lf", self.expireTime]
                      forServiceName:kBWXQZoneKeychainServiceNameSuffix updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:kBWXQZoneKeychainAccessToken andPassword:self.accessToken
                      forServiceName:kBWXQZoneKeychainServiceNameSuffix updateExisting:YES error:nil];
    
    [getAccessTokenRequest clearDelegatesAndCancel];
    [getAccessTokenRequest release];
    NSString *url = [kBWXQZoneGraphBaseURL stringByAppendingString:kBWXQZoneMe];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            appKey, @"oauth_consumer_key",
                            @"json",@"format",
                            token,@"access_token",
                            nil];
    NSString *urlString = [BWXShareRequest serializeURL:url
                                                 params:params
                                             httpMethod:@"GET"];
    getAccessTokenRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    getAccessTokenRequest.delegate = self;
    getAccessTokenRequest.didFinishSelector = @selector(didFinishRequest:);
    getAccessTokenRequest.didFailSelector = @selector(didFailRequest:);
    [getAccessTokenRequest startAsynchronous];
}
#pragma mark - BWXShareAuthWebViewDelegate
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    NSURL* url = request.URL;
	NSRange start = [[url absoluteString] rangeOfString:@"access_token="];
	if (start.location != NSNotFound)
	{
		NSString * token = [self getStringFromUrl:[url absoluteString] needle:@"access_token="];
		NSString * expireTime = [self getStringFromUrl:[url absoluteString] needle:@"expires_in="];
		NSDate *expirationDate =nil;
		
		if (expireTime != nil) {
			int expVal = [expireTime intValue];
			if (expVal == 0) {
				expirationDate = [NSDate distantFuture];
			} else {
				expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
			}
		}
		[webView hide];
		if ((token == (NSString *) [NSNull null]) || (token.length == 0)) {
            if ([self.delegate respondsToSelector:@selector(loginFail:error:)]) {
                [self.delegate loginFail:self error:[NSError errorWithDomain:BWXShareQZoneServiceDomain code:BWXShareQZoneServiceRequestAccessTokenError userInfo:nil]];
            }
		} else {
            [self requestOpenIdWithAccessToken:token expireTime:[expirationDate timeIntervalSince1970]];
		}
		return NO;
	}
	else
	{
		return YES;
	}
}

/**
 * Find a specific parameter from the url
 */
- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
	NSString * str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound) {
		NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		str = end.location == NSNotFound
		? [url substringFromIndex:offset]
		: [url substringWithRange:NSMakeRange(offset, end.location)];
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	
	return str;
}



-(void) didFinishRequest:(ASIHTTPRequest *) request {
    if (request == getAccessTokenRequest) {
        NSString *responseString = request.responseString;
        if ([[responseString substringToIndex:8] isEqualToString:@"callback"]) {
            responseString = [responseString substringWithRange:NSMakeRange(10, [responseString length]-13)];
        }
        id root = [responseString objectFromJSONString];
        NSString *openid = nil;
        if ([root isKindOfClass:[NSDictionary class]]) {
            openid = [root objectForKey:@"openid"];
        }
        
        if ([openid length] > 0) {
            [_openId release];
            _openId = [openid copy];
            [SFHFKeychainUtils storeUsername:kBWXQZoneKeychainOpenID andPassword:_openId
                              forServiceName:kBWXQZoneKeychainServiceNameSuffix updateExisting:YES error:nil];
            if ([self.delegate respondsToSelector:@selector(loginSuccess:)]) {
                [self.delegate loginSuccess:self];
            }
            
            [self requestUserInfo];
        }else {
            [self deleteAuthorizeDataInKeychain];
            if ([self.delegate respondsToSelector:@selector(loginFail:error:)]) {
                [self.delegate loginFail:self error:[NSError errorWithDomain:BWXShareQZoneServiceDomain code:BWXShareQZoneServiceRequestOpenIdError userInfo:nil]];
            }
        }
        
                [webView hide];

    } else if (request == userInfoRequest){
        id result = [userInfoRequest.responseString objectFromJSONString];
        if ([result isKindOfClass:[NSDictionary class]] && [[result objectForKey:@"ret"] intValue] == 0) {
            NSString *name = [result objectForKey:@"nickname"];
            if ([name length] > 0) {
                _user.userName = name;
                [SFHFKeychainUtils storeUsername:kBWXQZoneKeychainUserName andPassword:self.user.userName
                                  forServiceName:kBWXQZoneKeychainServiceNameSuffix updateExisting:YES error:nil];
            }
            
        }  
    } else if(request == shareImageRequest ||request == shareTextRequest) {
        id result = [userInfoRequest.responseString objectFromJSONString];
        int code = [[result objectForKey:@"ret"] intValue];
        if ([result isKindOfClass:[NSDictionary class]] && code == 0) {
            if ([self.delegate respondsToSelector:@selector(shareSuccess:)]) {
                [self.delegate shareSuccess:self];
            }
            
        } else {
                    NSLog(@"%@",request.responseString);
            if ([self.delegate respondsToSelector:@selector(shareFail:error:)]) {
                [self.delegate shareFail:self error:[NSError errorWithDomain:BWXShareQZoneServiceDomain code:code userInfo:nil]];
            }
        }
    }
}

-(void) didFailRequest:(ASIHTTPRequest *) request {
    if (request == getAccessTokenRequest) {
        [self deleteAuthorizeDataInKeychain];
        if ([self.delegate respondsToSelector:@selector(loginFail:error:)]) {
            [self.delegate loginFail:self error:request.error];
        }
        [webView hide];
    }else if(request == shareImageRequest || request == shareImageRequest) {
        if ([self.delegate respondsToSelector:@selector(shareFail:error:)]) {
            [self.delegate shareFail:self error:request.error];
        }
    }
}
@end
