//
//  UUCategoryDataProvider.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUCategoryDataProvider.h"

#define FETCH_CATEGORY_DETAIL @"http://www.gouqi001.com/jinyuan/app_main.php?category=%@&area=%@&pn=%d"

@interface UUCategoryDataProvider()

- (UUCategory *)getCategoryFromJson:(NSDictionary *)jsonDict;

@end


@implementation UUCategoryDataProvider

@synthesize delegate;

+ (UUCategoryDataProvider *)sharedInstance
{
    static dispatch_once_t pred;
    static UUCategoryDataProvider *provider = nil;
    dispatch_once(&pred, ^{ provider = [[self alloc] init]; });
    return provider;
}



- (void)fetchBeijingAreaDetailWithPageIndex:(NSInteger)index
{
    NSString *urlStr = [NSString stringWithFormat:FETCH_CATEGORY_DETAIL,@"project_display",@"beijing",index];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^successBlock) (AFHTTPRequestOperation *, id ) = ^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *jsonDict = [(NSData *)responseObject objectFromJSONData];
        
        DDLogInfo(@"%@",jsonDict);
        
        UUCategory *category = [self getCategoryFromJson:jsonDict];
        
        if([delegate respondsToSelector:@selector(beijingAreaDetailFetched:)]){
            [delegate beijingAreaDetailFetched:category];
        }
        
    };
    
    void (^failedBlock) (AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        
        DDLogInfo(@"error: %@ \n userinfo: %@", [error localizedDescription], error.userInfo);
        
        if([delegate respondsToSelector:@selector(beijingAreaDetailFailed:)]){
            [delegate beijingAreaDetailFailed:error];
        }
    };
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successBlock failure:failedBlock];
    [op start];
}

- (void)fetchChangjiangAreaDetailWithPageIndex:(NSInteger)index
{
    NSString *urlStr = [NSString stringWithFormat:FETCH_CATEGORY_DETAIL,@"project_display",@"changsanjiao",index];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^successBlock) (AFHTTPRequestOperation *, id ) = ^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *jsonDict = [(NSData *)responseObject objectFromJSONData];
        
        DDLogInfo(@"%@",jsonDict);
        
        UUCategory *category = [self getCategoryFromJson:jsonDict];
        
        if([delegate respondsToSelector:@selector(changjiangAreaDetailFetched:)]){
            [delegate changjiangAreaDetailFetched:category];
        }
        
    };
    
    void (^failedBlock) (AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        
        DDLogInfo(@"error: %@ \n userinfo: %@", [error localizedDescription], error.userInfo);
        
        if([delegate respondsToSelector:@selector(changjiangAreaDetailFailed:)]){
            [delegate changjiangAreaDetailFailed:error];
        }
    };
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successBlock failure:failedBlock];
    [op start];
}

- (void)fetchZhujiangAreaDetailWithPageIndex:(NSInteger)index
{
    NSString *urlStr = [NSString stringWithFormat:FETCH_CATEGORY_DETAIL,@"project_display",@"zhusanjiao",index];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^successBlock) (AFHTTPRequestOperation *, id ) = ^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *jsonDict = [(NSData *)responseObject objectFromJSONData];
        
        DDLogInfo(@"%@",jsonDict);
        
        UUCategory *category = [self getCategoryFromJson:jsonDict];
        
        if([delegate respondsToSelector:@selector(zhujiangAreaDetailFetched:)]){
            [delegate zhujiangAreaDetailFetched:category];
        }
        
    };
    
    void (^failedBlock) (AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        
        DDLogInfo(@"error: %@ \n userinfo: %@", [error localizedDescription], error.userInfo);
        
        if([delegate respondsToSelector:@selector(zhujiangAreaDetailFailed:)]){
            [delegate zhujiangAreaDetailFailed:error];
        }
    };
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successBlock failure:failedBlock];
    [op start];
}

- (void)fetchOtherAreaDetailWithPageIndex:(NSInteger)index
{
    NSString *urlStr = [NSString stringWithFormat:FETCH_CATEGORY_DETAIL,@"project_display",@"other",index];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^successBlock) (AFHTTPRequestOperation *, id ) = ^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *jsonDict = [(NSData *)responseObject objectFromJSONData];
        
        DDLogInfo(@"%@",jsonDict);
        
        UUCategory *category = [self getCategoryFromJson:jsonDict];
        
        if([delegate respondsToSelector:@selector(otherAreaDetailFetched:)]){
            [delegate otherAreaDetailFetched:category];
        }
        
    };
    
    void (^failedBlock) (AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        
        DDLogInfo(@"error: %@ \n userinfo: %@", [error localizedDescription], error.userInfo);
        
        if([delegate respondsToSelector:@selector(otherAreaDetailFailed:)]){
            [delegate otherAreaDetailFailed:error];
        }
    };
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successBlock failure:failedBlock];
    [op start];
}

- (void)fetchGoodPolicyDetailWithPageIndex:(NSInteger)index
{
    
    NSString *urlStr = [NSString stringWithFormat:FETCH_CATEGORY_DETAIL,@"good_policy",@"",index];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^successBlock) (AFHTTPRequestOperation *, id ) = ^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *jsonDict = [(NSData *)responseObject objectFromJSONData];
        
        DDLogInfo(@"%@",jsonDict);
        
        UUCategory *category = [self getCategoryFromJson:jsonDict];
        
        if([delegate respondsToSelector:@selector(goodPolicyDetailFetched:)]){
            [delegate goodPolicyDetailFetched:category];
        }
        
    };
    
    void (^failedBlock) (AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        
        DDLogInfo(@"error: %@ \n userinfo: %@", [error localizedDescription], error.userInfo);
        
        if([delegate respondsToSelector:@selector(goodPolicyDetailFailed:)]){
            [delegate goodPolicyDetailFailed:error];
        }
    };
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successBlock failure:failedBlock];
    [op start];
    
}

- (void)fetchNewInfoDetailWithPageIndex:(NSInteger)index
{
    
    NSString *urlStr = [NSString stringWithFormat:FETCH_CATEGORY_DETAIL,@"new_info",@"",index];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^successBlock) (AFHTTPRequestOperation *, id ) = ^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *jsonDict = [(NSData *)responseObject objectFromJSONData];
        
        DDLogInfo(@"%@",jsonDict);
        
        UUCategory *category = [self getCategoryFromJson:jsonDict];
        
        if([delegate respondsToSelector:@selector(newInfoDetailFetched:)]){
            [delegate newInfoDetailFetched:category];
        }
        
    };
    
    void (^failedBlock) (AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        
        DDLogInfo(@"error: %@ \n userinfo: %@", [error localizedDescription], error.userInfo);
        
        if([delegate respondsToSelector:@selector(newInfoDetailFailed:)]){
            [delegate newInfoDetailFailed:error];
        }
    };
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successBlock failure:failedBlock];
    [op start];

}

- (void)fetchActivityDetailWithPageIndex:(NSInteger)index
{    
    NSString *urlStr = [NSString stringWithFormat:FETCH_CATEGORY_DETAIL,@"active_calendar",@"",index];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    void (^successBlock) (AFHTTPRequestOperation *, id ) = ^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *jsonDict = [(NSData *)responseObject objectFromJSONData];
        
        DDLogInfo(@"%@",jsonDict);
        
        UUCategory *category = [self getCategoryFromJson:jsonDict];
        
        if([delegate respondsToSelector:@selector(activityDetailFetched:)]){
            [delegate activityDetailFetched:category];
        }
        
    };
    
    void (^failedBlock) (AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        
        DDLogInfo(@"error: %@ \n userinfo: %@", [error localizedDescription], error.userInfo);
        
        if([delegate respondsToSelector:@selector(activityDetailFailed:)]){
            [delegate activityDetailFailed:error];
        }
    };
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:successBlock failure:failedBlock];
    [op start];
}



- (UUCategory *)getCategoryFromJson:(NSDictionary *)jsonDict
{
    UUCategory *category = [[UUCategory alloc] init];
    
    category.categoryID = [jsonDict objectForKey:@"category"];
    category.categoryTitle = [jsonDict objectForKey:@"category_title"];
    if([jsonDict objectForKey:@"hasmore"]){
        category.hasmore = [[jsonDict objectForKey:@"hasmore"] boolValue];
    }
    
    NSArray *focusPages= [jsonDict objectForKey:@"focus"];
    if(focusPages && ![focusPages isKindOfClass:NSNull.class]){
        for(NSDictionary *pageJson in focusPages){
            UUPage *page = [[UUPage alloc] init];
            page.pageID = [pageJson objectForKey:@"id"];
            page.pageTitle = [pageJson objectForKey:@"page_title"];
            page.imageURL = [pageJson objectForKey:@"image_url"];
            [category.focusPages addObject:page];
        }
    }
    NSArray *listPgaesJson = [jsonDict objectForKey:@"block"];
    if(listPgaesJson && ![listPgaesJson isKindOfClass:NSNull.class]){
        for(NSDictionary *pageSectionJson in listPgaesJson){
            NSString *sectionKey = [pageSectionJson objectForKey:@"title"];
            NSArray *pagesJson = [pageSectionJson objectForKey:@"lines"];
            if(pagesJson && ![pagesJson isKindOfClass:NSNull.class] && [sectionKey isKindOfClass:NSString.class]){
                NSMutableArray *pages = [NSMutableArray array];
                for(NSDictionary *pageJson in pagesJson){
                    UUPage *page = [[UUPage alloc] init];
                    page.pageID = [pageJson objectForKey:@"id"];
                    page.pageTitle = [pageJson objectForKey:@"page_title"];
                    page.summary = [pageJson objectForKey:@"summary"];
                    page.thumbImageURL = [pageJson objectForKey:@"log_image_url"];
                    [pages addObject:page];
                }
                if([pages count]>0){
                    NSMutableDictionary *pageSection = [NSMutableDictionary dictionaryWithObject:pages forKey:sectionKey];
                    [category.listPages addObject:pageSection];
                }
            }
        }
    }
    
    return category;
}

@end
