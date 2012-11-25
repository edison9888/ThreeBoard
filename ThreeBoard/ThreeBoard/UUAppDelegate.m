//
//  UUAppDelegate.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUAppDelegate.h"

#import "UUMainVC.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "UUCategoryDataProvider.h"
#import "UUPageDataProvider.h"


@implementation UUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[UUMainVC alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //add logger
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UUCategoryDataProvider sharedInstance].delegate = self;
//    [[UUPageDataProvider sharedInstance] fetchPageInfoWithID:@"18"];
//    [[UUCategoryDataProvider sharedInstance] fetchActivityDetailWithPageIndex:0];
//    [[UUCategoryDataProvider sharedInstance] fetchGoodPolicyDetailWithPageIndex:0];
//    [[UUCategoryDataProvider sharedInstance] fetchNewInfoDetailWithPageIndex:0];
//    [[UUCategoryDataProvider sharedInstance] fetchProjectShowDetailWithSubID:@"beijing" pageIndex:0];
//    [[UUCategoryDataProvider sharedInstance] fetchProjectShowDetailWithSubID:@"changsanjiao" pageIndex:0];
//    [[UUCategoryDataProvider sharedInstance] fetchProjectShowDetailWithSubID:@"zhusanjiao" pageIndex:0];
//    [[UUCategoryDataProvider sharedInstance] fetchProjectShowDetailWithSubID:@"other" pageIndex:0];
    [[UUCategoryDataProvider sharedInstance] fetchBeijingAreaDetailWithPageIndex:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)beijingAreaDetailFetched:(UUCategory *)categoryDetail
{
    NSArray *sections = [categoryDetail listPages];
    for(NSDictionary *dic in sections){
        for(NSString *key in [dic allKeys]){
            DDLogInfo(@"key: %@ \n",key);
            NSArray *pages = [dic objectForKey:key];
            DDLogInfo(@"%d",[pages count]);
            for(UUPage *page in pages){
                DDLogInfo(@"%@ %@ %@ \n",page.pageTitle,page.summary,page.thumbImageURL);
            }
        }
    }
}

- (void)beijingAreaDetailFailed:(NSError *)error
{
    
}

@end
