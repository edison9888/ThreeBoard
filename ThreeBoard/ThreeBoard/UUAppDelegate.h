//
//  UUAppDelegate.h
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUCategoryDataProvider.h"

@class UUMainVC;

@interface UUAppDelegate : UIResponder <UIApplicationDelegate, UUCategoryDataProviderDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UUMainVC *viewController;

@end
