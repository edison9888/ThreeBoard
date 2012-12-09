//
//  UUSectionHeaderView.m
//  ThreeBoard
//
//  Created by garyliu on 12-12-9.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUSectionHeaderView.h"

@implementation UUSectionHeaderView

@synthesize titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self){
        self.frame = CGRectMake(0, 0, 320, kCommonSectionHeight);
        self.backgroundColor = UU_BG_DARK_SLATE_GRAY;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, kCommonSectionHeight)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = UU_TEXT_BLACK;
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:titleLabel];
        
    }
    return self;
}

@end
