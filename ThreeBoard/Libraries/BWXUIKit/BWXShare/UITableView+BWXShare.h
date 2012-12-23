//
//  UITableViewCell+BWXShare.h
//  BWXUIKit
//
//  Created by easy on 12-10-18.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (BWXShareSevice)
-(UIImage *) shareServiceBackgroundImageAtIndexPath:(NSIndexPath *) indexPath;
-(UIImage *) shareServiceSelectedBackgroundImageAtIndexPath:(NSIndexPath *) indexPath;
@end


@interface BWXShareServiceBindingCell : UITableViewCell
@property (nonatomic,retain) UIImage *serviceImage;
@property (nonatomic,copy) NSString *serviceName;
@property (assign,getter = isServiceBinding) BOOL serviceBinding;
@end


@class BWXShareServiceSwitchCell;

@protocol BWXShareServiceSwitchCellDelegate <NSObject>
-(void) shareServiceSwitchCell:(BWXShareServiceSwitchCell *) cell setOn:(BOOL) on;
@end

@interface BWXShareServiceSwitchCell : UITableViewCell
@property (nonatomic,retain) UIImage *serviceImage;
@property (nonatomic,copy) NSString *serviceName;
@property (nonatomic, getter = isOn) BOOL on;
@property (nonatomic, assign) id<BWXShareServiceSwitchCellDelegate> delegate;
@end


@interface BWXShareCancelCell : UITableViewCell
@property (nonatomic,copy) NSString *cancel;
@end