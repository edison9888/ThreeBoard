//
//  KFTool.m
//  KoalaFramework
//
//  Created by CHEN Menglin on 10/22/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "KFTool.h"

@implementation KFTool

+ (BOOL)createDirectory:(NSString*)path {
    if (nil == path || 0 == [path length]) {
        return NO;
    }
    
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        //KFLog(@"Already exist: %@", path);
        return YES;
    }
    else {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
          //  KFLog(@"Fail to create %@, because of: %@", path, [error description]);
            return NO;
        }
        else {
          //  KFLog(@"Succeed to create %@", path);
            return YES;
        }
    }
}

+ (BOOL)need4InchImage {
    return ([UIScreen mainScreen].bounds.size.height == 568);
}

@end
