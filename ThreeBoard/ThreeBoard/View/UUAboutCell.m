//
//  UUAboutCell.m
//  ThreeBoard
//
//  Created by garyliu on 12-12-15.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUAboutCell.h"

@implementation UUAboutCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.textColor = [UIColor colorWithHexString:@"333333"];;
        self.textLabel.font = [UIFont fontWithName:UU_CUSTOM_BODY_FONT size:16];
        self.textLabel.lineBreakMode=UILineBreakModeTailTruncation;
        
        UIImageView* next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"into_next_normal.png"] highlightedImage:[UIImage imageNamed:@"into_next_press.png"]];
		self.accessoryView = next;        
        
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    self.imageView.frame = CGRectMake(8, (self.frame.size.height - 24)/2, 24, 24);
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + 10;
    tmpFrame.size.width = 160;
    self.textLabel.frame = tmpFrame;
    
    CGRect rect = self.accessoryView.frame;
    rect.origin.x = 292;
    [self.accessoryView setFrame:rect];
}

@end
