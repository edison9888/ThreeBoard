//
//  BWXShareWeiboService.m
//  CoreShare
//
//  Created by Daly on 12-11-26.
//  Copyright (c) 2012年 baidu. All rights reserved.
//


#define kSinaWeiboAuthorizeURL     @"https://api.weibo.com/oauth2/authorize"
#define kSinaWeiboAccessTokenURL   @"https://api.weibo.com/oauth2/access_token"
#define kSinaWeiboGetUserInfoURL @"https://api.weibo.com/2/users/show.json"
#define kSinaWeiboShareImageURL @"https://upload.api.weibo.com/2/statuses/upload.json"
#define kSinaWeiboShareTextURL @"https://api.weibo.com/2/statuses/update.json"

#define kTimeOutInterval   180.0

#define kBWXSinaWBKeychainUserID @"BWXSinaWeiboKeychainUserID"
#define kBWXSinaWBKeychainAccessToken @"BWXSinaWeiboKeychainAccessToken"
#define kBWXSinaWBKeychainExpireTime @"BWXSinaWeiboKeychainExpireTime"
#define kBWXSinaWBKeychainUserName @"BWXSinaWeiboKeychainUserName"

#define kBWXSinaWBKeychainServiceNameSuffix    @"BWXSinaWeiBoServiceName"


#import "BWXShareSinaWeiboService.h"
#import "BWXShareAuthWebView.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "SFHFKeychainUtils.h"
#import "BWXShareUserModel.h"


@interface BWXShareSinaWeiboService()
{
    ASIHTTPRequest *userInfoRequest;
    ASIFormDataRequest *getAccessTokenRequest;
    ASIFormDataRequest *shareImageRequest;
    ASIFormDataRequest *shareTextRequest;
    BWXShareAuthWebView *webView;

}



@end


@implementation BWXShareSinaWeiboService
- (void)dealloc {
    [shareTextRequest clearDelegatesAndCancel];
    [shareTextRequest release],shareTextRequest = nil;
    [userInfoRequest clearDelegatesAndCancel];
    [userInfoRequest release],userInfoRequest = nil;
    [shareImageRequest clearDelegatesAndCancel];
    [shareImageRequest release],shareImageRequest = nil;
    [getAccessTokenRequest clearDelegatesAndCancel];
    [getAccessTokenRequest release],getAccessTokenRequest = nil;
    [webView release]; webView = nil;
    [super dealloc];
}

//+ (id)sharedInstance
//{
//    
//	static dispatch_once_t predicate;
//	static BWXShareSinaWeiboService *instance = nil;
//	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
//	return instance;
//}

- (id)init
{
    self = [super init];
    if (self) {
        appKey = [kBWXSinaWeiboAppKey copy];
        appSecret = [kBWXSinaWeiboAppSecret copy];
        redirectURI = [kBWXSinaWeiboRedirectUrl copy];
        _user = [[BWXShareUserModel alloc] init];
        _accessToken = [[SFHFKeychainUtils getPasswordForUsername:kBWXSinaWBKeychainAccessToken andServiceName:kBWXSinaWBKeychainServiceNameSuffix error:nil] copy];
        _expireTime = [[SFHFKeychainUtils getPasswordForUsername:kBWXSinaWBKeychainExpireTime andServiceName:kBWXSinaWBKeychainServiceNameSuffix error:nil] doubleValue];
        _user.userID = [SFHFKeychainUtils getPasswordForUsername:kBWXSinaWBKeychainUserID andServiceName:kBWXSinaWBKeychainServiceNameSuffix error:nil];
        
        _user.userName = [SFHFKeychainUtils getPasswordForUsername:kBWXSinaWBKeychainUserName andServiceName:kBWXSinaWBKeychainServiceNameSuffix error:nil];
        self.typeName = @"新浪微博";
        self.type = BWXShareTypeSinaWeibo;
    }
    return self;
}


#pragma mark - super funciton
- (void)login
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appKey, @"client_id",
                            @"code", @"response_type",
                            kBWXSinaWeiboRedirectUrl, @"redirect_uri",
                            @"mobile", @"display", nil];
    NSString *urlString = [BWXShareRequest serializeURL:kSinaWeiboAuthorizeURL
                                           params:params
                                       httpMethod:@"GET"];
    if (webView)  [webView release];
    
    webView = [[BWXShareAuthWebView alloc] init];
    
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kSinaWeiboAuthorizeURL]];
    
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


- (void)logout
{
    //del cookie
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kSinaWeiboAuthorizeURL]];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }

    [self deleteAuthorizeDataInKeychain];
    
    
    if ([self.delegate respondsToSelector:@selector(logoutSuccess:)])
    {
        [self.delegate logoutSuccess:self];
    }
}


- (BOOL)isLoggedIn
{
    return self.user.userID && self.accessToken && (self.expireTime > 0);
}


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


- (void)shareImage:(UIImage *)image withText:(NSString *)text
{
    if (![self isLoggedIn] && [self IsExpired]) {

        [self login];
        return;
    }
    if (image) {
        [shareImageRequest clearDelegatesAndCancel];
        [shareImageRequest release];
        shareImageRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:kSinaWeiboShareImageURL]] retain];
        shareImageRequest.delegate = self;
        shareImageRequest.timeOutSeconds = 120;
        [shareImageRequest setPostValue:self.accessToken forKey:@"access_token"];
        [shareImageRequest setPostValue:text forKey:@"status"];
        [shareImageRequest setData:UIImagePNGRepresentation(image) withFileName:@"post.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
        
        [shareImageRequest startAsynchronous];
    } else {
        [shareTextRequest clearDelegatesAndCancel];
        [shareImageRequest release];
        shareTextRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:kSinaWeiboShareTextURL]]retain];
        shareTextRequest.delegate = self;
        shareTextRequest.timeOutSeconds = 120;
        [shareTextRequest setPostValue:self.accessToken forKey:@"access_token"];
        [shareTextRequest setPostValue:text forKey:@"status"];        
        [shareTextRequest startAsynchronous];
        
    }
}







#pragma mark - ASI Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSDictionary *dict = [responseString objectFromJSONString];
    NSInteger errorCode = [dict objectForKey:@"error_code"]?[[dict objectForKey:@"error_code"] intValue]:0;;
    BOOL ifError = errorCode&&errorCode > 0;
    NSError *error = nil;
    if (ifError) {
        error =[NSError errorWithDomain:kSinaWeiboAuthorizeURL code:errorCode userInfo:dict];
    }
    NSLog(@"responseString = %@",dict);
    if (request == getAccessTokenRequest) {
        if (ifError) {
#if (DEBUG)
            NSLog(@"error:%@,%@",@"request access code error",[dict objectForKey:@"error"]);
#endif
            if ([self.delegate respondsToSelector:@selector(loginFail:error:)]) {
                [self.delegate loginFail:self error:error];
            }
            return;
        }
        [self deleteAuthorizeDataInKeychain];

        _expireTime = [[NSDate date] timeIntervalSince1970] + [[dict objectForKey:@"expires_in"] doubleValue];
        
        _user.userID = [dict objectForKey:@"uid"] ;
        _accessToken = [[dict objectForKey:@"access_token"] retain];
        [SFHFKeychainUtils storeUsername:kBWXSinaWBKeychainUserID andPassword:self.user.userID
                          forServiceName:kBWXSinaWBKeychainServiceNameSuffix updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kBWXSinaWBKeychainAccessToken andPassword:self.accessToken
                          forServiceName:kBWXSinaWBKeychainServiceNameSuffix updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kBWXSinaWBKeychainExpireTime andPassword:[NSString stringWithFormat:@"%lf", self.expireTime]
                          forServiceName:kBWXSinaWBKeychainServiceNameSuffix updateExisting:YES error:nil];
        [self getUserInfo];
    } else if (request == userInfoRequest) {
        if (ifError) {
#if (DEBUG)
            NSLog(@"error:%@,%@",@"request user name error",[dict objectForKey:@"error"]);
#endif
            if ([self.delegate respondsToSelector:@selector(loginFail:error:)]) {
                [self.delegate loginFail:self error:error];
            }
        }
        _user.userName = [dict objectForKey:@"name"];
        [SFHFKeychainUtils storeUsername:kBWXSinaWBKeychainUserName andPassword:self.user.userName
                          forServiceName:kBWXSinaWBKeychainServiceNameSuffix updateExisting:YES error:nil];
        if ([self.delegate respondsToSelector:@selector(loginSuccess:)]) {
            [self.delegate loginSuccess:self];
        }
    } else if (shareImageRequest == request || shareTextRequest == request) {
        if (ifError) {
#if (DEBUG)
            NSLog(@"error:%@,%@",@"share pic request error",[dict objectForKey:@"error"]);
#endif
            if ([self.delegate respondsToSelector:@selector(shareFail:error:)]) {
                [self.delegate shareFail:self error:error];
            }
            return;
        }
        if([self.delegate respondsToSelector:@selector(shareSuccess:)]) {
            [self.delegate shareSuccess:self];
        }
    }
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
#if (DEBUG)
    NSLog(@"request error = %@",error);

#endif
    if (request == getAccessTokenRequest) {
//        NSLog(@"%@ %@",@"获取授权失败",error);
    } else if (request == userInfoRequest) {
    
//        NSLog(@"%@ %@",@"获取授权失败",error);

    } else if (shareImageRequest == request) {
    
    
    }
}


#pragma mark - api Request

- (void)getUserInfo
{
    NSString *tempURLStr = [NSString stringWithFormat:@"%@?access_token=%@&uid=%@",
                            kSinaWeiboGetUserInfoURL,
                            self.accessToken,
                            self.user.userID];
     userInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tempURLStr]];
    userInfoRequest.delegate = self;
    userInfoRequest.timeOutSeconds = 120;
    [userInfoRequest startAsynchronous];

}

- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code
{
    
    [getAccessTokenRequest clearDelegatesAndCancel];
    [getAccessTokenRequest release];
    getAccessTokenRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:kSinaWeiboAccessTokenURL]] retain];
    getAccessTokenRequest.delegate = self;
    getAccessTokenRequest.timeOutSeconds = 120;
    [getAccessTokenRequest setPostValue:appKey forKey:@"client_id"];
    [getAccessTokenRequest setPostValue:appSecret forKey:@"client_secret"];
    [getAccessTokenRequest setPostValue:@"authorization_code" forKey:@"grant_type"];
    [getAccessTokenRequest setPostValue:redirectURI forKey:@"redirect_uri"];
    [getAccessTokenRequest setPostValue:code forKey:@"code"];
    [getAccessTokenRequest startAsynchronous];
    
    
    
}

- (void)deleteAuthorizeDataInKeychain
{
    _user.userID = nil;
    _user.userName = nil;
    [_accessToken release],_accessToken = nil;
    _expireTime = 0;
    
    [SFHFKeychainUtils deleteItemForUsername:kBWXSinaWBKeychainUserID
                              andServiceName:kBWXSinaWBKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kSinaWeiboAccessTokenURL
                              andServiceName:kBWXSinaWBKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kSinaWeiboAuthorizeURL
                              andServiceName:kBWXSinaWBKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kBWXSinaWBKeychainUserName
                              andServiceName:kBWXSinaWBKeychainServiceNameSuffix error:nil];

}


#pragma mark - BWXShareAuthWebViewDelegate
- (void)authorizeWebViewDidReceiveAuthorizeCode:(NSString *)code
{
    [webView hide];
    
    
    // if not canceled
    if (![code isEqualToString:@"21330"])
    {
        [self requestAccessTokenWithAuthorizeCode:code];
    }
    
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    NSLog(@"%@",request);
    if (range.location != NSNotFound)
    {
        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        NSLog(@"code = %@",code);
        [self authorizeWebViewDidReceiveAuthorizeCode:code];
    }
    
    return YES;
}

@end
