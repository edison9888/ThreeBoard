//
//  WXCustomCell.h
//  shenbian
//
//  Created by Daly Dai on 12-7-14.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BWXCustomCellView;

@interface BWXCustomCell : UITableViewCell {
	BWXCustomCellView *cellView;
}

@property(nonatomic, retain) BWXCustomCellView *cellView;
@property(nonatomic, copy)UIColor *selectColor;

@end
