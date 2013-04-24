//
//  UUAppDelegate.h
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUMainVC;

@interface UUAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window; 

@property (strong, nonatomic) UINavigationController *viewController;

@end
