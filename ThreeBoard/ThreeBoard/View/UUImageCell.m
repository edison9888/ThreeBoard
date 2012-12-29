//
//  UUImageCell.m
//  ThreeBoard
//
//  Created by garyliu on 12-12-8.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUImageCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation UUImageCell

@synthesize imageURL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.textLabel.font = [UIFont fontWithName:UU_CUSTOM_BODY_FONT size:14];
        self.textLabel.lineBreakMode=UILineBreakModeTailTruncation;
        
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.textColor = [UIColor colorWithHexString:@"999999"];
		self.detailTextLabel.font = [UIFont fontWithName:UU_CUSTOM_BODY_FONT size:12];
        self.detailTextLabel.lineBreakMode=UILineBreakModeTailTruncation;
        
        UIImageView* next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"into_next_normal.png"] highlightedImage:[UIImage imageNamed:@"into_next_press.png"]];
		self.accessoryView = next;
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        CALayer *layer = [self.imageView layer];
        [layer setCornerRadius:5];
        [layer setMasksToBounds:YES];
        [layer setBorderWidth:1];
        [layer setBorderColor:[UU_IMAGEVIEW_BORDER_COLOR CGColor]];
        self.imageView.image = [UIImage imageNamed:@"logo.png"];
        
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
//    self.imageView.frame = CGRectMake(8, 3, 54, 54);
    self.imageView.frame = CGRectMake(8, (self.frame.size.height - 40)/2, 40, 40);
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + 10;
    tmpFrame.size.width = 200;
    self.textLabel.frame = tmpFrame;
    
    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + 10;
    tmpFrame.size.width = 200;
    self.detailTextLabel.frame = tmpFrame;
    
    CGRect rect = self.accessoryView.frame;
    rect.origin.x = 292;
    [self.accessoryView setFrame:rect];
}

- (void)showImage
{
    if(self.imageView){
        self.imageView.image = [UIImage imageNamed:@"logo.png"];
    }
    if(self.imageURL && ![self.imageURL isEqualToString:@""]){
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager cancelForDelegate:self];
        [manager downloadWithURL:[NSURL URLWithString:self.imageURL] delegate:self];
    }
}

#pragma mark  SDWebImageDownloaderDelegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url
{
    NSString *urlStr = [url absoluteString];
    if(self.imageURL && [self.imageURL isEqualToString:urlStr]){
        if(self.imageView != nil){
            self.imageView.image = image;
        }
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url
{
    if(self.imageView){
        self.imageView.image = [UIImage imageNamed:@"logo.png"];
    }
}

@end
