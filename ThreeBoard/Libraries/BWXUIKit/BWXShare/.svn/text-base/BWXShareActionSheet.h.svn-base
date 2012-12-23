//
//  BWXShareActionController.h
//  BWXUIKit
//
//  Created by easy on 12-10-19.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWXShareBaseService.h"
#import "BWXShareServiceModel.h"

@class BWXShareActionSheet;


@protocol BWXShareActionSheetDelegate <NSObject>
@optional
-(void) shareActionSheet:(BWXShareActionSheet *) actionSheet didSelectShareService:(BWXShareBaseService *) service;
-(void)shareActionSheetCancelled:(BWXShareActionSheet *) actionSheet;
@end

@interface BWXShareActionSheet : NSObject
@property (nonatomic, assign) id<BWXShareActionSheetDelegate> delegate;

-(id) init;
-(id) initWithServiceTypes:(NSArray *) serviceTypes;

-(void) show;
- (void)dismiss;
@end