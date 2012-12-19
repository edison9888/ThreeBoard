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
#import "UUNavigationController.h"
#import "BaiduMobStat.h"

@interface UUAppDelegate()


@end

@implementation UUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UUNavigationController *navController = [[UUNavigationController alloc] initWithRootViewController:[[UUMainVC alloc] init]];
    navController.delegate = self;
    self.viewController = navController;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //add logger
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
#if(TARGET_IPHONE_SIMULATOR)

#else
    //add baidu statistics
    if(BaiduStatisticsSDK){
        BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
        statTracker.channelId = @"appStore";
        statTracker.enableExceptionLog = YES;
        [statTracker startWithAppId:@"516cf31176"];
    }
#endif
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}



#pragma mark UINavigationControllerDelegate Method

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
	if([navigationController.viewControllers count ] > 1)
    {
        NSString* buttonTitle = @"返回";
		viewController.navigationItem.leftBarButtonItem = [UUUIHelper createBackBarItem:viewController.navigationController action:@selector(popViewControllerAnimated:) title:buttonTitle];
	}
	
}

@end
