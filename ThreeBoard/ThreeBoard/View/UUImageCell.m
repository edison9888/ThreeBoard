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
        CALayer *layer = [self.imageView layer];
        [layer setCornerRadius:5];
        [layer setMasksToBounds:YES];
        [layer setBorderWidth:1];
        [layer setBorderColor:[TING_IMAGEVIEW_BORDER_COLOR CGColor]];
        
        if(self.imageView){
            self.imageView.image = [UIImage imageNamed:@"logo_image_default"];
        }
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    self.imageView.frame = CGRectMake(kImageViewOffsetX, kImageViewOffsetY, kImageViewWidth, kImageViewHeight);
    
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

- (void)showImage
{
    if(self.imageURL && ![self.imageURL isEqualToString:@""]){
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager cancelForDelegate:self];
        [manager downloadWithURL:[NSURL URLWithString:self.imageURL] delegate:self];
    }else{
        if(self.imageView){
            self.imageView.image = [UIImage imageNamed:@"logo_image_default"];
        }
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
        self.imageView.image = [UIImage imageNamed:@"logo_image_default"];
    }
}

@end
