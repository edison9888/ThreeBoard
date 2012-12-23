//
//  BWXShareWeixinService.m
//  BWXUIKit
//
//  Created by easy on 12-12-7.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "BWXShareWeixinService.h"
#import "WXApi.h"

@interface BWXShareWeixinService () <UIAlertViewDelegate>{
    BWXShareWeixinServiceType _weixinType;
}

@end

@implementation BWXShareWeixinService
@synthesize weixinType = _weixinType;
- (id)initWithWeixinType:(BWXShareWeixinServiceType)type {
    self = [super init];
    if (self) {
        switch (type) {
            case BWXShareWeixinServiceTypeTimeline:
                _weixinType = BWXShareWeixinServiceTypeTimeline;
                self.typeName = @"微信朋友圈";
                break;
            default:
                _weixinType = BWXShareWeixinServiceTypeDefault;
                self.typeName = @"微信";
                break;
        }
    }
    return self;
}
- (BOOL)IsExpired {
    return NO;
}

- (void)login {
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"未安装微信" message:@"是否安装微信?" delegate:self cancelButtonTitle:@"安装" otherButtonTitles: @"取消",nil];
        [av show];
        [av release];
    }else if (![WXApi isWXAppSupportApi]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"不支持微信" message:@"当前系统不支持微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        [av release];
    }
}

- (void)logout {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"微信无需注销" message:@"当微信被卸载时,会自动解除注销" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [av show];
    [av release];
}

- (BOOL)isLoggedIn {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (void)shareImage:(UIImage*)image withText:(NSString*)text {
    
    SendMessageToWXReq *req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = image == nil;
    req.text = text;
    switch (_weixinType) {
        case BWXShareWeixinServiceTypeTimeline:
            req.scene = WXSceneTimeline;
            break;
        default:
            req.scene = WXSceneSession;
            break;
    }
    

    
    if (image) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        UIImage *thumbImage = image;
        CGSize size1 = thumbImage.size;
        CGFloat wp = size1.width/size.width;
        CGFloat hp = size1.height/size.height;
        CGSize size2 = size1;
        if (wp > hp) {
            if (wp > 1) {
                size2.width = size.width;
                size2.height = size1.height/wp;
            }
        } else {
            if (hp > 1) {
                size2.height = size.height;
                size2.width = size1.width/hp;
            }
        }
        if (!CGSizeEqualToSize(size1, size2)) {
            UIGraphicsBeginImageContext(size2);
            [image drawInRect:CGRectMake(0, 0, size2.width, size2.height)];
            thumbImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        NSData *data = nil;
        float compressionQuality = 0.1;
        int count = 0;
        while (1) {
            data = UIImageJPEGRepresentation(thumbImage, compressionQuality);
            if (data.length < 32 * 1024) {
                break;
            }
            compressionQuality /= 10;
            count++;
            if (count >= 5) {
                break;
            }
        }
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.thumbData = data;
        NSLog(@"%d",message.thumbData.length);
//        [message setThumbImage:image];
        WXImageObject *object = [WXImageObject object];
        object.imageData = UIImagePNGRepresentation(image);
        message.mediaObject = object;
        message.title = text;
        message.description = text;
        req.message = message;
    }
    
    if([WXApi sendReq:req]) {
        if([self.delegate respondsToSelector:@selector(shareSuccess:)]) {
            [self.delegate shareSuccess:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(shareFail:error:)]) {
            [self.delegate shareFail:self error:nil];
        }
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
    }
}

@end
