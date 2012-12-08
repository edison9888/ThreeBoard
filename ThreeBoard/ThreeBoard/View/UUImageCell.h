//
//  UUImageCell.h
//  ThreeBoard
//
//  Created by garyliu on 12-12-8.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUBaseCell.h"
#import "SDWebImageManager.h"

@interface UUImageCell : UUBaseCell<SDWebImageManagerDelegate>

@property (nonatomic, strong) NSString *imageURL;

- (void)showImage;

@end
