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

//		UIImageView* backView = [[UIImageView alloc] initWithFrame:self.frame] ;
//		backView.backgroundColor = UU_SELECTED_BG_COLOR;
//		self.selectedBackgroundView = backView;
	
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
	UIColor* backgroundColour = UU_BG_WHITE;
    
	UIColor* topColor = [UIColor colorWithHexString:@"ffffff"];
	UIColor* bottomColor = [UIColor colorWithHexString:@"eaeaea"];
	
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
