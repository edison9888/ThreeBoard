//
//  BWXShareRequest.h
//  CoreShare
//
//  Created by Daly on 12-11-26.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    BWXShareRequestPostDataTypeNone,
	BWXShareRequestPostDataTypeNormal,		// for normal data post, such as "user=name&password=psd"
	BWXShareRequestPostDataTypeMultipart,    // for uploading images and files.
}BWXShareRequestPostDataType;


@interface BWXShareRequest : NSObject
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;


@end

