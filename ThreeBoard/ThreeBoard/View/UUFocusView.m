//
//  UUFocusView.m
//  ThreeBoard
//
//  Created by garyliu on 12-12-9.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUFocusView.h"

@implementation UUFocusView

@synthesize focusImageView;
@synthesize focusTitleLabel;
@synthesize focusButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.focusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
        self.focusImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.focusImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:focusImageView];
        
        UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-36, 320, 36)];
        shadowImageView.backgroundColor = [UIColor blackColor];
        shadowImageView.alpha = 0.5;
        [self addSubview:shadowImageView];
        
        self.focusTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.frame.size.height-36, 200, 36)];
        focusTitleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        focusTitleLabel.font = [UIFont fontWithName:UU_CUSTOM_BODY_FONT size:14];
        focusTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:focusTitleLabel];
        
        self.focusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
        focusButton.backgroundColor = [UIColor clearColor];
        [self addSubview:focusButton];
    }
    return self;
}


@end
