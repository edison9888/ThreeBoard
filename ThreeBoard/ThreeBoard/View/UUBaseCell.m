//
//  UUBaseCell.m
//  ThreeBoard
//
//  Created by garyliu on 12-12-8.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUBaseCell.h"
#import "UIColor-Expanded.h"

@implementation UUBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.textColor = TING_TEXT_BLACK;
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.textColor = TING_TEXT_LIGHT_BLACK;
//		UIImageView* backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finger_press.png"]] ;
//		backView.frame = self.frame;
//		self.selectedBackgroundView = backView;
        
        UIImageView* next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"into_next_normal.png"] highlightedImage:[UIImage imageNamed:@"into_next_press.png"]];
		self.accessoryView = next;
        
		self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        self.textLabel.lineBreakMode=UILineBreakModeTailTruncation;
		self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.lineBreakMode=UILineBreakModeTailTruncation;
        
        self.imageView.frame = CGRectMake(kImageViewOffsetX, kImageViewOffsetY, kImageViewWidth, kImageViewHeight);
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        
        CGRect tmpFrame = self.textLabel.frame;
        tmpFrame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + kTextLabelOffset;
        tmpFrame.size.width = 160;
        self.textLabel.frame = tmpFrame;
        
        tmpFrame = self.detailTextLabel.frame;
        tmpFrame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + kTextLabelOffset;
        tmpFrame.size.width = 160;
        self.detailTextLabel.frame = tmpFrame;
        
        CGRect rect = self.accessoryView.frame;
        rect.origin.x = 292;
        [self.accessoryView setFrame:rect];
        
	}
	return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
	
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor* backgroundColour = TING_BG_WHITE;
    
	UIColor* topColor = [UIColor colorWithHexString:@"ffffff"];
	UIColor* bottomColor = TING_DEVIDE_LINE_COLOR;
	
	[backgroundColour set];
	CGContextFillRect(context, rect);
	
    CGContextSetLineWidth(context, 0.5);
    [topColor set];
    
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, 320, 0);
	CGContextStrokePath(context);
    
    [bottomColor set];
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, rect.size.height - 0.5);
    CGContextAddLineToPoint(context, 320, rect.size.height - 0.5);
    CGContextStrokePath(context);
}


@end
