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

@implementation UUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[UUMainVC alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.gouqi001.com/jinyuan/app_page.php?page_id=17"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:
                                         ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        DDLogInfo(@"IP Address: %@", [JSON valueForKeyPath:@"category"]);
    }
                                                                                        failure:
                            ^( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON )
    {
        DDLogInfo(@"error: %@",[error localizedDescription]);
                                                                                            
    }];
    
    [operation start];
        
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
