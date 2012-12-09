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
        self.focusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
        [self addSubview:focusImageView];
        
        UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 320, 20)];
        shadowImageView.backgroundColor = UU_TEXT_BLACK;
        shadowImageView.alpha = 0.7;
        [self addSubview:shadowImageView];
        
        self.focusTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 150, 20)];
        focusTitleLabel.textColor = [UIColor whiteColor];
        focusTitleLabel.font = [UIFont systemFontOfSize:12];
        focusTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:focusTitleLabel];
        
        self.focusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
        focusButton.backgroundColor = [UIColor clearColor];
        [self addSubview:focusButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
