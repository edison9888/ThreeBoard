//
//  UUPageDataProvider.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUPageDataProvider.h"
#import "JSONKit.h"
#import "AFHTTPRequestOperation.h"
#import "SDURLCache.h"

#define FETCH_PAGE_DETAIL @"http://www.gouqi001.com/jinyuan/app_page.php?page_id=%@"

@implementation UUPageDataProvider

@synthesize delegate;

+ (UUPageDataProvider *)sharedInstance
{
    static dispatch_once_t pred;
    static UUPageDataProvider *provider = nil;
    dispatch_once(&pred, ^{ provider = [[self alloc] init]; });
    return provider;
}

- (id)init
{
    self = [super init];
    if(self){
        SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
                                                             diskCapacity:1024*1024*5 // 5MB disk cache
                                                                 diskPath:[SDURLCache defaultCachePath]];
        urlCache.ignoreMemoryOnlyStoragePolicy = YES;
        [NSURLCache setSharedURLCache:urlCache];
    }
    return self;
}

- (void)fetchPageInfoWithID:(NSString *)pageID
{
    NSString *urlStr = [NSString stringWithFormat:FETCH_PAGE_DETAIL,pageID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^successBlock) (AFHTTPRequestOperation *, id ) = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *jsonDict = [(NSData *)responseObject objectFromJSONData];
        
        DDLogInfo(@"%@",jsonDict);
        
        UUPage *page = [[UUPage alloc] init];
        page.pageID = [jsonDict objectForKey:@"page_id"];
        page.pageTitle = [jsonDict objectForKey:@"page_title"];
        page.imageURL = [jsonDict objectForKey:@"image_url"];
        page.publishTime = [jsonDict objectForKey:@"publish_time"];
        page.categoryID = [jsonDict objectForKey:@"category"];
        NSArray *contents = [jsonDict objectForKey:@"page_content"];
        if(contents && ![contents isKindOfClass:NSNull.class]){
            for (NSString *paragraph in contents) {
                if(paragraph && [paragraph isKindOfClass:NSString.class])
                [page.contents addObject:paragraph];
            }
        }
        
        if([delegate respondsToSelector:@selector(pageInfoFetched:)]){
            [delegate pageInfoFetched:page];
        }
        
    };
    
    void (^failedBlock) (AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        DDLogInfo(@"error: %@ \n userinfo: %@", [error localizedDescription], error.userInfo);
        
        if([delegate respondsToSelector:@selector(pageInfoFailed:)]){
            [delegate pageInfoFailed:error];
        }
    };
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successBlock failure:failedBlock];
    [op start];
    
    
    
}

@end
