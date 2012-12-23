//
//  BWXShareWeixinService.h
//  BWXUIKit
//
//  Created by easy on 12-12-7.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "BWXShareBaseService.h"
typedef enum {
    BWXShareWeixinServiceTypeDefault,//Session
    BWXShareWeixinServiceTypeTimeline
} BWXShareWeixinServiceType;

@interface BWXShareWeixinService : BWXShareBaseService
@property (nonatomic, assign, readonly) BWXShareWeixinServiceType weixinType;
-(id) initWithWeixinType:(BWXShareWeixinServiceType) type;
@end
