//
//  KFTool.h
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/22/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFTool : NSObject

// 创建指定路径，返回表示是否创建成功
+ (BOOL)createDirectory:(NSString*)path;

// 是否是iPhone 5
+ (BOOL)need4InchImage;

@end
