//
//  BWXShareWeiboService.m
//  CoreShare
//
//  Created by Daly on 12-11-26.
//  Copyright (c) 2012年 baidu. All rights reserved.
//


#define kRenrenAuthorizeURL     @"https://graph.renren.com/oauth/authorize"
#define kRenrenAccessTokenURL   @"https://graph.renren.com/oauth/token"
#define kRenrenAPIBaseURL @"http://api.renren.com/restserver.do"


#define kTimeOutInterval   180.0

#define kBWXRenrenKeychainUserID @"BWXRenrenKeychainUserID"
#define kBWXRenrenKeychainAccessToken @"BWXRenrenKeychainAccessToken"
#define kBWXRenrenKeychainExpireTime @"BWXRenrenKeychainExpireTime"
#define kBWXRenrenKeychainUserName @"BWXRenrenKeychainUserName"

#define kBWXRenrenKeychainServiceNameSuffix    @"BWXRenrenServiceName"
#define kBWXRenrenWidgetDialogUA @"18da8a1a68e2ee89805959b6c8441864"
#define kBWXRenrenRedirectUrl @"http://widget.renren.com/callback.html"

#import "BWXShareRenrenService.h"
#import "BWXShareAuthWebView.h"
#import "BWXShareRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "SFHFKeychainUtils.h"
#import "BWXShareUserModel.h"
#import <CommonCrypto/CommonDigest.h>



@interface BWXShareRenrenService()
{
    ASIFormDataRequest *userInfoRequest;
    ASIFormDataRequest *getAccessTokenRequest;
    ASIFormDataRequest *shareImageRequest;
    ASIFormDataRequest *shareTextRequest;
    BWXShareAuthWebView *webView;
    NSString *APIKey;

}


@end


@implementation BWXShareRenrenService
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
    [APIKey release],APIKey= nil;
    [super dealloc];
}

//+ (id)sharedInstance
//{
//    
//	static dispatch_once_t predicate;
//	static BWXShareRenrenService *instance = nil;
//	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
//	return instance;
//}

- (id)init
{
    self = [super init];
    if (self) {
        appKey = [kBWXRenrenAppKey copy];
        appSecret = [kBWXRenrenAppSecret copy];
        redirectURI = [kBWXRenrenRedirectUrl copy];
        APIKey = [kBWXRenrenAPIKey copy];
        _user = [[BWXShareUserModel alloc] init];
        _accessToken = [[SFHFKeychainUtils getPasswordForUsername:kBWXRenrenKeychainAccessToken andServiceName:kBWXRenrenKeychainServiceNameSuffix error:nil] copy];
        _expireTime = [[SFHFKeychainUtils getPasswordForUsername:kBWXRenrenKeychainExpireTime andServiceName:kBWXRenrenKeychainServiceNameSuffix error:nil] doubleValue];
        _user.userID = [SFHFKeychainUtils getPasswordForUsername:kBWXRenrenKeychainUserID andServiceName:kBWXRenrenKeychainServiceNameSuffix error:nil];
        
        _user.userName = [SFHFKeychainUtils getPasswordForUsername:kBWXRenrenKeychainUserName andServiceName:kBWXRenrenKeychainServiceNameSuffix error:nil];
        self.typeName = @"人人网";
        self.type = BWXShareTypeRenren;

    }
    return self;
}


#pragma mark - super funciton
- (void)login
{
    
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* graphCookies = [cookies cookiesForURL:
                             [NSURL URLWithString:@"http://graph.renren.com"]];
	
	for (NSHTTPCookie* cookie in graphCookies) {
		[cookies deleteCookie:cookie];
	}
	NSArray* widgetCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://widget.renren.com"]];
	
	for (NSHTTPCookie* cookie in widgetCookies) {
		[cookies deleteCookie:cookie];
	}
    [self deleteAuthorizeDataInKeychain];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:APIKey, @"client_id",
                            @"token", @"response_type",
                            kBWXRenrenRedirectUrl, @"redirect_uri",
                            @"photo_upload publish_feed", @"scope",
                            @"touch", @"display",
                            kBWXRenrenWidgetDialogUA,@"ua",nil];
    NSString *urlString = [BWXShareRequest serializeURL:kRenrenAuthorizeURL
                                           params:params
                                       httpMethod:@"GET"];
    if (webView)  [webView release];
    
    webView = [[BWXShareAuthWebView alloc] init];
    
    


    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    webView.webView.delegate = self;
    [webView.webView loadRequest:request];
    [webView show];

}


- (void)logout
{
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* graphCookies = [cookies cookiesForURL:
                             [NSURL URLWithString:@"http://graph.renren.com"]];
	
	for (NSHTTPCookie* cookie in graphCookies) {
		[cookies deleteCookie:cookie];
	}
	NSArray* widgetCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://widget.renren.com"]];
	
	for (NSHTTPCookie* cookie in widgetCookies) {
		[cookies deleteCookie:cookie];
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
        shareImageRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:kRenrenAPIBaseURL]] retain];
        shareImageRequest.delegate = self;
        shareImageRequest.timeOutSeconds = 180;
        [shareImageRequest setPostValue:@"photos.upload" forKey:@"method"];
        [shareImageRequest setData:UIImagePNGRepresentation(image) withFileName:@"post.jpg" andContentType:@"image/jpeg" forKey:@"upload"];
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"photos.upload",@"method", nil];
        [self addCommonPostParam:shareImageRequest andParamDict:dict];
        
        [shareImageRequest startAsynchronous];
    } else {
        [shareTextRequest clearDelegatesAndCancel];
        [shareTextRequest release];
        shareTextRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:kRenrenAPIBaseURL]] retain];
        shareTextRequest.delegate = self;
        shareTextRequest.timeOutSeconds = 120;
        [shareTextRequest setPostValue:@"feed.publishFeed" forKey:@"method"];
        [shareTextRequest setPostValue:@"test" forKey:@"name"];
        [shareTextRequest setPostValue:text forKey:@"description"];
        [shareTextRequest setPostValue:@"http://baidu.com" forKey:@"url"];
        [shareTextRequest setPostValue:@"test" forKey:@"message"];

        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"feed.publishFeed",@"method", nil];
        [dict setValue:@"test" forKey:@"name"];
        [dict setValue:text forKey:@"description"];
        [dict setValue:@"http://baidu.com" forKey:@"url"];
        [dict setValue:@"test" forKey:@"message"];
        
        [self addCommonPostParam:shareTextRequest andParamDict:dict];
        [shareTextRequest startAsynchronous];
        
    }
}






#pragma mark - ASI Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"responseString = %@",responseString);
    id dict = [responseString objectFromJSONString];
    if ([dict isKindOfClass:[NSArray class]]) {
        
        dict  = [((NSArray*)dict) objectAtIndex:0];
    }
    NSInteger errorCode = [[dict objectForKey:@"error_code"] intValue];
    NSLog(@"error_msg = %@",[dict objectForKey:@"error_msg"]);
    BOOL ifError = errorCode&&errorCode > 0;
    NSError *error = nil;
    if (ifError) {
        error =[NSError errorWithDomain:@"http://renren.com" code:errorCode userInfo:dict];
    }
    NSLog(@"dict = %@",dict);
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
        _expireTime = [[NSDate date] timeIntervalSince1970] + [[dict objectForKey:@"expires_in"] doubleValue];
      
        _user.userID = [dict objectForKey:@"uid"];
        _accessToken = [[dict objectForKey:@"access_token"] copy];
        [SFHFKeychainUtils storeUsername:kBWXRenrenKeychainUserID andPassword:self.user.userID
                          forServiceName:kBWXRenrenKeychainServiceNameSuffix updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kBWXRenrenKeychainAccessToken andPassword:self.accessToken
                          forServiceName:kBWXRenrenKeychainServiceNameSuffix updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kBWXRenrenKeychainExpireTime andPassword:[NSString stringWithFormat:@"%lf", self.expireTime]
                          forServiceName:kBWXRenrenKeychainServiceNameSuffix updateExisting:YES error:nil];
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
        _user.userID = [[dict objectForKey:@"uid"] stringValue];
        [SFHFKeychainUtils storeUsername:kBWXRenrenKeychainUserName andPassword:self.user.userName
                          forServiceName:kBWXRenrenKeychainServiceNameSuffix updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:kBWXRenrenKeychainUserID andPassword:self.user.userID
                          forServiceName:kBWXRenrenKeychainServiceNameSuffix updateExisting:YES error:nil];
        if ([self.delegate respondsToSelector:@selector(loginSuccess:)]) {
            [self.delegate loginSuccess:self];
        }
    } else if ( shareTextRequest == request) {
        if (![[dict objectForKey:@"post_id"] intValue]> 0) {
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
    }else if ( shareImageRequest == request) {
        if (![[dict objectForKey:@"pid"] intValue]> 0) {
#if (DEBUG)
            NSLog(@"error:%@,%@",@"share text request error",[dict objectForKey:@"error"]);
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
}


#pragma mark - api Request

- (void)getUserInfo
{

    
    [userInfoRequest clearDelegatesAndCancel];
    [userInfoRequest release];
    userInfoRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:kRenrenAPIBaseURL]] retain];
    userInfoRequest.delegate = self;
    userInfoRequest.timeOutSeconds = 120;
    
    [userInfoRequest setPostValue:@"users.getInfo" forKey:@"method"];
    [userInfoRequest setPostValue:@"name" forKey:@"fields"];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users.getInfo",@"method", nil];
    [dict setValue:@"name" forKey:@"fields"];

    [self addCommonPostParam:userInfoRequest andParamDict:dict];
    [userInfoRequest startAsynchronous];
}



- (void)addCommonPostParam:(ASIFormDataRequest*)aRequest andParamDict:(NSMutableDictionary*)dic
{

//    aRequest.userAgentString = @"Renren iOS SDK v3.0 (iPhone Simulator; iPhone OS 6.0)";

    [dic setValue:APIKey forKey:@"api_key"];
    [dic setValue:@"1.0" forKey:@"v"];
    [dic setValue:self.accessToken forKey:@"access_token"];
    [dic setValue:appSecret forKey:@"session_key"];
    [dic setValue:@"json" forKey:@"format"];
    [dic setValue:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] forKey:@"call_id"];


    
    [aRequest setPostValue:APIKey forKey:@"api_key"];
    [aRequest setPostValue:@"1.0" forKey:@"v"];
    [aRequest setPostValue:self.accessToken forKey:@"access_token"];
    [aRequest setPostValue:appSecret forKey:@"session_key"];
    [aRequest setPostValue:@"json" forKey:@"format"];
    [aRequest setPostValue:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] forKey:@"call_id"];

    NSString *sig = [BWXShareRenrenService generateSig:dic secretKey:appSecret];

    [aRequest setPostValue:sig forKey:@"sig"];
    
}


+ (NSString *)generateSig:(NSMutableDictionary *)paramsDict secretKey:(NSString *)secretKey{
    NSMutableString* joined = [NSMutableString string];
	NSArray* keys = [paramsDict.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (id obj in [keys objectEnumerator]) {
		id value = [paramsDict valueForKey:obj];
		if ([value isKindOfClass:[NSString class]]) {
			[joined appendString:obj];
			[joined appendString:@"="];
			[joined appendString:value];
		}
	}
	[joined appendString:secretKey];
	return [self md5HexDigest:joined];
}
+ (NSString *)md5HexDigest:(NSString *)input{
    const char* str = [input UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
    NSMutableString *returnHashSum = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [returnHashSum appendFormat:@"%02x", result[i]];
    }
	
	return returnHashSum;
}

- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code
{
    
    [getAccessTokenRequest clearDelegatesAndCancel];
    [getAccessTokenRequest release];
    getAccessTokenRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:kRenrenAccessTokenURL]] retain];
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
    
    [SFHFKeychainUtils deleteItemForUsername:kBWXRenrenKeychainUserID
                              andServiceName:kBWXRenrenKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kRenrenAccessTokenURL
                              andServiceName:kBWXRenrenKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kRenrenAuthorizeURL
                              andServiceName:kBWXRenrenKeychainServiceNameSuffix error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kBWXRenrenKeychainUserName
                              andServiceName:kBWXRenrenKeychainServiceNameSuffix error:nil];

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
    NSURL *url = request.URL;
    NSString *query = [url fragment]; // url中＃字符后面的部分。
    if (!query) {
        query = [url query];
    }
    NSDictionary *params = [self parseURLParams:query];
    NSString *accessTokenTemp = [params objectForKey:@"access_token"];
    NSString *errorReason = [params objectForKey:@"error"];
    if(nil != errorReason) {
        return NO;
    }
    if (navigationType == UIWebViewNavigationTypeLinkClicked)/*点击链接*/{
        BOOL userDidCancel = ((errorReason && [errorReason isEqualToString:@"login_denied"])||[errorReason isEqualToString:@"access_denied"]);
        if(userDidCancel){
        }else {
//            NSString *q = [url absoluteString];
//            if (![q hasPrefix:self.serverURL]) {
//                [[UIApplication sharedApplication] openURL:request.URL];
//            }
        }
        return NO;
    }
    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {//提交表单
        NSString *state = [params objectForKey:@"flag"];
        if ((state && [state isEqualToString:@"success"])||accessTokenTemp) {

            _expireTime = [[NSDate date] timeIntervalSince1970] + [[params objectForKey:@"expires_in"] doubleValue];
            _accessToken = [[params objectForKey:@"access_token"] copy];
            [SFHFKeychainUtils storeUsername:kBWXRenrenKeychainAccessToken andPassword:self.accessToken
                              forServiceName:kBWXRenrenKeychainServiceNameSuffix updateExisting:YES error:nil];
            [SFHFKeychainUtils storeUsername:kBWXRenrenKeychainExpireTime andPassword:[NSString stringWithFormat:@"%lf", self.expireTime]
                              forServiceName:kBWXRenrenKeychainServiceNameSuffix updateExisting:YES error:nil];
            [webView hide];
            [self getUserInfo];

            
        
        }
    }
    

    return YES;
}

#pragma mark - private function
- (NSDictionary *)parseURLParams:(NSString *)query{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *val =[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
	}
    return [params autorelease];
}
@end
