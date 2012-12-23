//
//  UITableViewCell+BWXShare.m
//  BWXUIKit
//
//  Created by easy on 12-10-18.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "UITableView+BWXShare.h"
#import "BWXUIKit.h"

@implementation UITableView (BWXShareSevice)
-(UIImage *) shareServiceBackgroundImageAtIndexPath:(NSIndexPath *) indexPath {
    if (indexPath == nil) {
        return nil;
    }
    
    NSUInteger number = [self numberOfRowsInSection:[indexPath section]];
    if ([indexPath row] == 0) {
        return BWXPNGImage(@"image-cell-top", @"BWXShare.bundle");
    } else if([indexPath row] == number - 1) {
        return BWXPNGImage(@"image-cell-bottom", @"BWXShare.bundle");
    } else if ([indexPath row] > 0 && [indexPath row] < number - 1) {
        return BWXPNGImage(@"image-cell-center", @"BWXShare.bundle");
    }
    return nil;
}

-(UIImage *) shareServiceSelectedBackgroundImageAtIndexPath:(NSIndexPath *) indexPath {
    if (indexPath == nil) {
        return nil;
    }
    
    NSUInteger number = [self numberOfRowsInSection:[indexPath section]];
    if ([indexPath row] == 0) {
        return BWXPNGImage(@"image-cell-top-pressed", @"BWXShare.bundle");
    } else if([indexPath row] == number - 1) {
        return BWXPNGImage(@"image-cell-bottom-pressed", @"BWXShare.bundle");
    } else if ([indexPath row] > 0 && [indexPath row] < number - 1) {
        return BWXPNGImage(@"image-cell-center-pressed", @"BWXShare.bundle");
    }
    return nil;
}
@end


@interface BWXShareServiceBindingCell () {
    UIImageView *_serviceImageView;//noretain
    UILabel *_serviceLabel;         //noretain
    UILabel *_serviceBindingLabel;  //noretain
    UIImageView *_arrowImageView;   //noretain
    
    
    UIImage *_serviceImage;
    NSString *_serviceName;
    BOOL _serviceBinding;
    
    UIImage *_arrowImage;
}

@end

@implementation BWXShareServiceBindingCell
@synthesize serviceImage = _serviceImage;
@synthesize serviceName = _serviceName;
@synthesize serviceBinding = _serviceBinding;

- (void)dealloc
{
    [_serviceImage release],_serviceImage = nil;
    [_serviceName release],_serviceName = nil;
    [_arrowImage release],_arrowImage = nil;
    [super dealloc];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _serviceImageView = [[[UIImageView alloc] init] autorelease];
        [self.contentView addSubview:_serviceImageView];
        
        _serviceLabel = [[[UILabel alloc] init] autorelease];
        _serviceLabel.font = BWXFontWithSize(16);
        _serviceLabel.backgroundColor = [UIColor clearColor];
        _serviceLabel.textColor = [UIColor colorWithRed:(CGFloat)0x3a/255 green:(CGFloat)0x3a/255 blue:(CGFloat)0x3a/255 alpha:1];
        [self.contentView addSubview:_serviceLabel];
        
        _serviceBindingLabel = [[[UILabel alloc] init] autorelease];
        _serviceBindingLabel.font = BWXFontWithSize(14);
        _serviceBindingLabel.backgroundColor = [UIColor clearColor];
        _serviceBindingLabel.textColor = [UIColor colorWithRed:(CGFloat)0x73/255 green:(CGFloat)0x73/255 blue:(CGFloat)0x73/255 alpha:1];
        [self.contentView addSubview:_serviceBindingLabel];
        
        _arrowImage = [BWXPNGImage(@"image-cell-arrow", @"BWXShare.bundle") retain];
        _arrowImageView = [[[UIImageView alloc] init] autorelease];
        [self.contentView addSubview:_arrowImageView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;

    _serviceImageView.image = _serviceImage;
    if (_serviceImage != nil) {
        _serviceImageView.frame = CGRectMake(0, floorf(CGRectGetMidY(bounds) - _serviceImage.size.height/2), _serviceImage.size.width, _serviceImage.size.height);
    } else {
        _serviceImageView.frame = CGRectZero;
    }
    
    _arrowImageView.image = _arrowImage;
    _arrowImageView.frame = CGRectMake(CGRectGetMaxX(bounds)-10-_arrowImage.size.width, floorf(CGRectGetMidY(bounds) - _arrowImage.size.height/2), _arrowImage.size.width, _arrowImage.size.height);
    
    
    NSString *serviceBindingString = _serviceBinding ? @"已绑定" : @"未绑定";
    CGSize bindSize = [serviceBindingString sizeWithFont:_serviceBindingLabel.font];
    _serviceBindingLabel.text = serviceBindingString;
    _serviceBindingLabel.frame = CGRectMake(CGRectGetWidth(bounds)-20-bindSize.width-CGRectGetWidth(_arrowImageView.bounds), floorf(CGRectGetMidY(bounds) - bindSize.height/2), bindSize.width, bindSize.height);
    
    if (_serviceBinding) {
        _serviceBindingLabel.textColor = [UIColor colorWithRed:(CGFloat)0x73/255 green:(CGFloat)0x73/255 blue:(CGFloat)0x73/255 alpha:1];
    } else {
        _serviceBindingLabel.textColor = [UIColor colorWithRed:(CGFloat)0x48/255 green:(CGFloat)0x48/255 blue:(CGFloat)0x48/255 alpha:1];
    }
    
    _serviceLabel.text = _serviceName;
    if ([_serviceName length] > 0) {
        CGSize serviceSize = [_serviceName sizeWithFont:_serviceLabel.font];
        CGFloat maxServiceWidth = CGRectGetMinX(_serviceBindingLabel.frame) - CGRectGetMaxX(_serviceImageView.frame);
        if (serviceSize.width > maxServiceWidth) {  //限制宽度
            serviceSize.width = maxServiceWidth;
        }
        _serviceLabel.frame = CGRectMake(CGRectGetMaxX(_serviceImageView.frame), floorf(CGRectGetMidY(bounds)-serviceSize.height/2), serviceSize.width, serviceSize.height);
    } else {
        _serviceLabel.frame = CGRectZero;
    }
    
}

-(void)setServiceImage:(UIImage *)serviceImage {
    if (serviceImage != _serviceImage) {
        [_serviceImage release];
        _serviceImage = [serviceImage retain];
        [self layoutSubviews];
    }
}

-(UIImage *)serviceImage {
    return _serviceImage;
}

-(void)setServiceName:(NSString *)serviceName {
    if (serviceName != _serviceName) {
        [_serviceName release];
        _serviceName = [serviceName copy];
        [self layoutSubviews];
    }
}

-(NSString *)serviceName {
    return _serviceName;
}

-(void)setServiceBinding:(BOOL)serviceBinding {
    if (serviceBinding != _serviceBinding) {
        _serviceBinding = serviceBinding;
        [self layoutSubviews];
    }
}

-(BOOL)isServiceBinding {
    return _serviceBinding;
}

@end

@interface BWXShareServiceSwitchCell () {
    UIImageView *_serviceImageView; //noretain
    UILabel *_serviceLabel;         //noretain
    UISwitch *_shareSwitch;         //noretain
    
    id<BWXShareServiceSwitchCellDelegate> _delegate;
    UIImage *_serviceImage;
    NSString *_serviceName;
    BOOL _on;
}

@end
@implementation BWXShareServiceSwitchCell
@synthesize serviceImage = _serviceImage;
@synthesize serviceName = _serviceName;
@synthesize on = _on;
@synthesize delegate = _delegate;
- (void)dealloc {
    _delegate = nil;
    [_serviceImage release],_serviceImage = nil;
    [_serviceName release],_serviceName = nil;
    [super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _serviceImageView = [[[UIImageView alloc] init] autorelease];
        [self.contentView addSubview:_serviceImageView];
        
        _serviceLabel = [[[UILabel alloc] init] autorelease];
        _serviceLabel.font = BWXFontWithSize(16);
        _serviceLabel.backgroundColor = [UIColor clearColor];
        _serviceLabel.textColor = [UIColor colorWithRed:(CGFloat)0x3a/255 green:(CGFloat)0x3a/255 blue:(CGFloat)0x3a/255 alpha:1];
        [self.contentView addSubview:_serviceLabel];
        
        
        _shareSwitch = [[[UISwitch alloc] init] autorelease];
        [_shareSwitch addTarget:self action:@selector(shareSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_shareSwitch];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    
    _serviceImageView.image = _serviceImage;
    if (_serviceImage != nil) {
        _serviceImageView.frame = CGRectMake(0, floorf(CGRectGetMidY(bounds) - _serviceImage.size.height/2), _serviceImage.size.width, _serviceImage.size.height);
    } else {
        _serviceImageView.frame = CGRectZero;
    }
    
    CGSize switchSize = _shareSwitch.frame.size;
    _shareSwitch.frame = CGRectMake(CGRectGetWidth(bounds) - switchSize.width - 10, floorf(CGRectGetMidY(bounds)-switchSize.height/2), switchSize.width, switchSize.height);
    _shareSwitch.on = _on;
    
    _serviceLabel.text = _serviceName;
    if ([_serviceName length] > 0) {
        CGSize serviceSize = [_serviceName sizeWithFont:_serviceLabel.font];
        CGFloat maxServiceWidth = CGRectGetMinX(_shareSwitch.frame) - CGRectGetMaxX(_serviceImageView.frame);
        if (serviceSize.width > maxServiceWidth) {  //限制宽度
            serviceSize.width = maxServiceWidth;
        }
        _serviceLabel.frame = CGRectMake(CGRectGetMaxX(_serviceImageView.frame), floorf(CGRectGetMidY(bounds)-serviceSize.height/2), serviceSize.width, serviceSize.height);
    } else {
        _serviceLabel.frame = CGRectZero;
    }

}

-(void) shareSwitchValueChanged:(id) sender {
    _on = [sender isOn];
    if ([_delegate respondsToSelector:@selector(shareServiceSwitchCell:setOn:)]) {
        [_delegate shareServiceSwitchCell:self setOn:_on];
    }
}

-(void)setServiceImage:(UIImage *)serviceImage {
    if (serviceImage != _serviceImage) {
        [_serviceImage release];
        _serviceImage = [serviceImage retain];
        [self layoutSubviews];
    }
}

-(UIImage *)serviceImage {
    return _serviceImage;
}

-(void)setServiceName:(NSString *)serviceName {
    if (serviceName != _serviceName) {
        [_serviceName release];
        _serviceName = [serviceName copy];
        [self layoutSubviews];
    }
}

-(NSString *)serviceName {
    return _serviceName;
}

-(void)setShare:(BOOL)share {
    if (share !=  _on) {
        _on = share;
        [self layoutSubviews];
    }
}

@end

@interface BWXShareCancelCell () {
    UILabel *_cancelLabel;//noretain
    NSString *_cancel;
}

@end

@implementation BWXShareCancelCell
@synthesize cancel = _cancel;

- (void)dealloc
{
    [_cancel release],_cancel = nil;
    [super dealloc];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cancelLabel = [[[UILabel alloc] initWithFrame:self.bounds] autorelease];
        _cancelLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _cancelLabel.textAlignment = UITextAlignmentCenter;
        _cancelLabel.backgroundColor = [UIColor clearColor];
        _cancel = [@"取消" copy];
        _cancelLabel.text = _cancel;
        [self addSubview:_cancelLabel];
    }
    return self;
}

-(void)setCancel:(NSString *)cancel {
    if (_cancel != cancel) {
        [_cancel release];
        _cancel = [cancel copy];
        if (_cancel == nil) {
            _cancel = [@"取消" copy];
        }
        _cancelLabel.text = _cancel;
    }
}
-(NSString *)cancel {
    return _cancel;
}
@end