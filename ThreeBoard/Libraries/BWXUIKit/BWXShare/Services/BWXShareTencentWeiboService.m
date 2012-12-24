//
//  BWXShareTencentWeiboService.m
//  CoreShare
//
//  Created by Daly on 12-11-28.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "BWXShareTencentWeiboService.h"
#import "BWXShareAuthWebView.h"
#import "BWXShareRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "SFHFKeychainUtils.h"
#import "BWXShareUserModel.h"


#define kTencentWeiboAuthorizeURL     @"https://open.t.qq.com/cgi-bin/oauth2/authorize"
#define kTencentWeiboAccessTokenURL   @"https://open.t.qq.com/cgi-bin/oauth2/access_token"
#define kTencentWeiboGetUserInfoURL @""
#define kTencentWeiboShareImageURL @"https://open.t.qq.com/api/t/add_pic"
#define kTencentWeiboShareTextURL @"http://open.t.qq.com/api/t/add"

#define kBWXTencentWBKeychainServiceNameSuffix    @"BWXTencentWeiBoServiceName"


#define kTimeOutInterval   180.0

//#define kBWXTencentWBKeychainUserID @"BWXTencentWeiboKeychainUserID"
#define kBWXTencentWBKeychainAccessToken @"BWXTencentWeiboKeychainAccessToken"
#define kBWXTencentWBKeychainExpireTime @"BWXTencentWeiboKeychainExpireTime"
#define kBWXTencentWBKeychainUserName @"BWXTencentWeiboKeychainUserName"
#define kBWXTencentWBKeychainOpenID @"BWXTencentWeiboKeychainOpenID"



@interface BWXShareTencentWeiboService()
{
    ASIHTTPRequest *userInfoRequest;
    ASIFormDataRequest *getAccessTokenRequest;
    ASIFormDataRequest *shareImageRequest;
    ASIFormDataRequest *shareTextRequest;
    BWXShareAuthWebView *webView;
    NSString *openId;
    
}


@end


@implementation BWXShareTencentWeiboService
- (void)dealloc
{

    [shareTextRequest clearDelegatesAndCancel];
    [shareTextRequest release],shareTextRequest = nil;
    [userInfoRequest clearDelegatesAndCancel];
    [userInfoRequest release],userInfoRequest = nil;
    [shareImageRequest clearDelegatesAndCancel];
    [shareImageRequest release],shareImageRequest = nil;
    [getAccessTokenRequest clearDelegatesAndCancel];
    [getAccessTokenRequest release],getAccessTokenRequest = nil;
    webView.webView.delegate = nil;
    [webView release]; webView = nil;
    [super dealloc];
}

//+ (id)sharedInstance
//{
//
//	static dispatch_once_t predicate;
//	static BWXShareTencentWeiboService *instance = nil;
//	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
//	return instance;
//}

- (id)init
{
    self = [super init];
    if (self) {
        appKey = [kBWXTencentWeiboAppKey copy];
        appSecret = [kBWXTencentWeiboAppSecret copy];
        redirectURI = [kBWXTencentWeiboRedirectUrl copy];
        openId = [[SFHFKeychainUtils getPasswordForUsername:kBWXTencentWBKeychainOpenID andServiceName:kBWXTencentWBKeychainServiceNameSuffix error:nil] copy];
        _user = [[BWXShareUserModel alloc] init];
        _accessToken = [[SFHFKeychainUtils getPasswordForUsername:kBWXTencentWBKeychainAccessToken andServiceName:kBWXTencentWBKeychainServiceNameSuffix error:nil] copy];
        _expireTime = [[SFHFKeychainUtils getPasswordForUsername:kBWXTencentWBKeychainExpireTime andServiceName:kBWXTencentWBKeychainServiceNameSuffix error:nil] doubleValue];
//        _user.userID = [SFHFKeychainUtils getPasswordForUsername:kBWXTencentWBKeychainUserID andServiceName:kBWXTencentWBKeychainServiceNameSuffix error:nil];
        
        _user.userName = [SFHFKeychainUtils getPasswordForUsername:kBWXTencentWBKeychainUserName andServiceName:kBWXTencentWBKeychainServiceNameSuffix error:nil];
        self.typeName = @"腾讯微博";
        self.type = BWXShareTypeTencentWeibo;
        
    }
    return self;
}


#pragma mark - super funciton
- (void)login
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appKey, @"client_id",
                            @"code", @"response_type",
                            kBWXTencentWeiboRedirectUrl, @"redirect_uri",
                            @"mobile", @"display", nil];
    NSString *urlString = [BWXShareRequest serializeURL:kTencentWeiboAuthorizeURL
                                                 params:params
                                             httpMethod:@"GET"];
    if (webView)  [webView release];

    webView = [[BWXShareAuthWebView alloc] init];
    
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kTencentWeiboAuthorizeURL]];
    
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
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kTencentWeiboAuthorizeURL]];
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
    return self.user.userName && self.accessToken && (self.expireTime > 0);
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

        shareImageRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:kTencentWeiboShareImageURL]] retain];
        shareImageRequest.delegate = self;
        shareImageRequest.timeOutSeconds = 120;
        [shareImageRequest setPostValue:text forKey:@"content"];
        [self addCommonPostParam:shareImageRequest];
        [shareImageRequest setData:UIImagePNGRepresentation(image) withFileName:@"post.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
        
        [shareImageRequest startAsynchronous];
    } else {
        [shareTextRequest clearDelegatesAndCancel];
        [shareTextRequest release];
        shareTextRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:kTencentWeiboShareTextURL]] retain];
        shareTextRequest.delegate = self;
        shareTextRequest.timeOutSeconds = 120;
        [shareTextRequest setPostValue:text forKey:@"content"];
        
        [self addCommonPostParam:shareTextRequest];
        [shareTextRequest startAsynchronous];
        
    }
}


- (void)addCommonPostParam:(ASIFormDataRequest*)aRequest
{
    [aRequest setPostValue:appKey forKey:@"oauth_consumer_key"];
    [aRequest setPostValue:self.accessToken forKey:@"access_token"];
    [aRequest setPostValue:openId forKey:@"openid"];
    [aRequest setPostValue:@"" forKey:@"clientip"];
    [aRequest setPostValue:@"2.a" forKey:@"oauth_version"];
    [aRequest setPostValue:@"json" forKey:@"format"];


}




#pragma mark - ASI Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSDictionary *dict = request == getAccessTokenRequest? [self createDicforAccesstoken:responseString]  : [responseString objectFromJSONString];
    NSInteger errorCode = [[dict objectForKey:@"error_code"] intValue];
    BOOL ifError = errorCode&&errorCode > 0;
    NSError *error = nil;
    if (ifError) {
        error =[NSError errorWithDomain:nil code:errorCode userInfo:dict];
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
        _user.userName = [dict objectForKey:@"nick"];
        _accessToken = [[dict objectForKey:@"access_token"] retain];
        openId = [[dict objectForKey:@"openid"] retain];
        [SFHFKeychainUtils storeUsername:kBWXTencentWBKeychainOpenID andPassword:openId
                          forServiceName:kBWXTencentWBKeychainServiceNameSuffix updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kBWXTencentWBKeychainAccessToken andPassword:self.accessToken
                          forServiceName:kBWXTencentWBKeychainServiceNameSuffix updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kBWXTencentWBKeychainExpireTime andPassword:[NSString stringWithFormat:@"%lf", self.expireTime]
                          forServiceName:kBWXTencentWBKeychainServiceNameSuffix updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kBWXTencentWBKeychainUserName andPassword:self.user.userName
                          forServiceName:kBWXTencentWBKeychainServiceNameSuffix updateExisting:YES error:nil];
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
                            kTencentWeiboGetUserInfoURL,
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
    getAccessTokenRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:kTencentWeiboAccessTokenURL]] retain];
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
    
    [SFHFKeychainUtils deleteItemForUsername:kBWXTencentWBKeychainOpenID
                              andServiceName:kBWXTencentWBKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kTencentWeiboAccessTokenURL
                              andServiceName:kBWXTencentWBKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kTencentWeiboAuthorizeURL
                              andServiceName:kBWXTencentWBKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kBWXTencentWBKeychainUserName
                              andServiceName:kBWXTencentWBKeychainServiceNameSuffix error:nil];
    
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
        NSString *query = [request.URL query];
        NSArray *sep = [query componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        for (NSString *param in sep) {
            NSArray *sp = [param componentsSeparatedByString:@"="];
            [dictParam setObject:[sp objectAtIndex:1] forKey:[sp objectAtIndex:0]];
        }
        
        NSString *code = [dictParam objectForKey:@"code"];
        NSLog(@"code = %@",code);
        [self authorizeWebViewDidReceiveAuthorizeCode:code];
    }
    
    return YES;
}

#pragma mark - private function
- (NSDictionary *)createDicforAccesstoken:(NSString *)returnString{
    NSMutableDictionary *accessDic = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *returnArray = [[NSArray alloc] initWithArray:[returnString componentsSeparatedByString:@"&"]];
    for (int i = 0; i < [returnArray count]; i++) {
        NSArray *array = [[returnArray objectAtIndex:i] componentsSeparatedByString:@"="];
        [accessDic setObject:[array objectAtIndex:1]forKey:[array objectAtIndex:0]];
    }
    [returnArray release];
    return [accessDic autorelease];
}

@end
