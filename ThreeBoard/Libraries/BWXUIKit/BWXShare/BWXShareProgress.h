//
//  BWXShareProgress.h
//  BWXUIKit
//
//  Created by easy on 12-10-26.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWXUIKit.h"

@interface BWXShareProgress : NSObject
+(id) shareProgress;

- (void) showLoadingWithMessage:(NSString *) message;
- (void) showMessage:(NSString *) message;
- (void) hide;
@end
