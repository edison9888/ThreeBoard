//
//  BWXShareViewController.m
//  BWXUIKit
//
//  Created by easy on 12-10-17.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "BWXShareViewController.h"
#import "BWXShareBaseService.h"
#import "BWXShareServiceModel.h"
#import "BWXShareCenter.h"
#import "BWXShareProgress.h"
#import "BWXShareUserModel.h"
#import "UIBarHelper.h"


#define BWXShareViewControllerTextInputMaxSize 140

@interface BWXShareViewController () <UITextViewDelegate>{
    NSArray *_images;
    NSString *_content;
    NSUInteger _currentSelectImageIndex;
    
    //UI
    
    UIImageView *_serviceBackgroundImageView;               //noretain
    
    UILabel *_shareToLabel;     //分享到                     //noretain
    UILabel *_serviceLabel;     //服务label 如:新浪微博       //noretain
    UILabel *_nameLabel;        //第三方登录名                //noretain
    
    UITextView *_contentTextView;   //分享内容输入框          //noretain
    
    UIView *_bottomView;                                    //noretain
    NSMutableArray *_imageButtons;       //图片按钮
    
    UILabel *_countLabel;                                   //noretain
    
    
    CGFloat _shareBaseY;
    
    
    CGFloat _topViewHeight;
    CGFloat _bottomViewHeight;
    
    NSUInteger _maxNumberOfImages;
    
    BWXShareBaseService *_service;
}

@end

@implementation BWXShareViewController
@synthesize service = _service;
@synthesize content = _content;
@synthesize images = _images;

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"service.user.userName"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_service release];
    [_content release];
    [_images release];
    [_imageButtons release];
    [super dealloc];
}
-(id)init {
    self = [super init];
    if (self) {
            _maxNumberOfImages = 5;
        
    }
    return self;
}

-(void)loadView {
    [super loadView];
    
    self.view.backgroundColor = UU_BG_SLATE_GRAY;
    
    
    //分享栏
    UIImage *serviceBackgroundImage = BWXPNGImage(@"image-bar-background",@"BWXShare.bundle");
    _topViewHeight = serviceBackgroundImage.size.height;
    
    _serviceBackgroundImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), serviceBackgroundImage.size.height)] autorelease];
    _serviceBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    _serviceBackgroundImageView.image = serviceBackgroundImage;
    _serviceBackgroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:_serviceBackgroundImageView];
    
    
    _shareBaseY = 9.0f;
    //分享到
    NSString *shareToString = @"分享到";
    UIFont *shareToFont = BWXFontWithSize(12);
    CGSize sharedSize = [shareToString sizeWithFont:shareToFont];
    _shareToLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, _shareBaseY, sharedSize.width, sharedSize.height)] autorelease];
    _shareToLabel.text = shareToString;
    _shareToLabel.font =shareToFont;
    _shareToLabel.backgroundColor = [UIColor clearColor];
    [_serviceBackgroundImageView addSubview:_shareToLabel];
    
    //分享到“xxx”
    NSString *serviceString = _service.typeName;
    UIFont *serviceFont = BWXFontWithSize(12);
    CGSize serviceSize = [serviceString sizeWithFont:serviceFont];
    _serviceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_shareToLabel.frame), _shareBaseY, serviceSize.width, serviceSize.height)] autorelease];
    _serviceLabel.text = serviceString;
    _serviceLabel.font =serviceFont;
    _serviceLabel.backgroundColor = [UIColor clearColor];
    _serviceLabel.textColor = [UIColor colorWithRed:(CGFloat)0x27/255 green:(CGFloat)0x73/255 blue:(CGFloat)0xDC/255 alpha:1];
    [_serviceBackgroundImageView addSubview:_serviceLabel];
    
    //分享人
    NSString *nameString = _service.user.userName;
    UIFont *nameFont = BWXFontWithSize(14);
    CGSize nameSize = [nameString sizeWithFont:nameFont];
    _nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - nameSize.width - 10, _shareBaseY, nameSize.width, nameSize.height)] autorelease];
    _nameLabel.text = nameString;
    _nameLabel.font =nameFont;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_serviceBackgroundImageView addSubview:_nameLabel];
    
    //内容输入
    _contentTextView = [[[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_serviceBackgroundImageView.frame), CGRectGetWidth(self.view.bounds), 100)] autorelease];
//    _contentTextView.font = BWXFontWithSize(16);
    _contentTextView.font = [UIFont systemFontOfSize:16];
    _contentTextView.textColor = [UIColor colorWithRed:(CGFloat)0x37/255 green:(CGFloat)0x37/255 blue:(CGFloat)0x37/255 alpha:1];
    _contentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _contentTextView.delegate = self;
    [self.view addSubview:_contentTextView];
    
    _contentTextView.text = _content;
    
    _bottomViewHeight = 60.0f;
    
    _bottomView = [[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame), CGRectGetWidth(self.view.frame), _bottomViewHeight)] autorelease];
    _bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _bottomView.clipsToBounds = YES;
    _bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bottomView];
//    _contentTextView.inputAccessoryView = _bottomView;
    
    _imageButtons = [[NSMutableArray alloc] init];
    [self updateWithImages];
    
    _countLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_bottomView.frame)-60, CGRectGetHeight(_bottomView.frame) - 12 - 10, 48, 12)] autorelease];
    _countLabel.textAlignment = UITextAlignmentRight;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _countLabel.textColor = [UIColor colorWithRed:(CGFloat)0x75/255 green:(CGFloat)0x75/255 blue:(CGFloat)0x75/255 alpha:1];
    _countLabel.font = BWXFontWithSize(12);
    _countLabel.text = [NSString stringWithFormat:@"%d",BWXShareViewControllerTextInputMaxSize];
    [_bottomView addSubview:_countLabel];

    //导航栏
//    self.navigationItem.leftBarButtonItem = [UIBarHelper leftBarButtonItemWithTitle:@"返回" font:BWXFontWithSize(14) target:self action:@selector(leftBarButtonPressed:)];
//    
//    self.navigationItem.rightBarButtonItem = [UIBarHelper rightBarButtonItemWithTitle:@"分享" font:BWXFontWithSize(14) target:self action:@selector(rightBarButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem = [UIBarHelper createNormalBarButtonItemWithTitle:@"返回" position:CGPointMake(0, 0) target:self selector:@selector(leftBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [UIBarHelper createNormalBarButtonItemWithTitle:@"分享" position:CGPointMake(0, 0) target:self selector:@selector(rightBarButtonPressed:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    _contentTextView.selectedRange = NSMakeRange(0, 0);
    
    [self addObserver:self forKeyPath:@"service.user.userName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_contentTextView becomeFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) keyboardDidShow:(NSNotification *) notify {
    
    CGRect endFrame = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect currentFrame = [self.view convertRect:self.view.frame toView:self.view.window];

    CGFloat height = CGRectGetMinY(endFrame) - CGRectGetMinY(currentFrame);
    
    CGFloat textViewHeight = height - _topViewHeight - _bottomViewHeight;
    
    
    _contentTextView.frame = CGRectMake(0, _topViewHeight, CGRectGetWidth(self.view.frame), textViewHeight);

    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_contentTextView.frame), CGRectGetWidth(self.view.bounds), _bottomViewHeight);
    
}

-(void) updateWithServiceModel {
    CGSize serviceSize = [self.service.typeName sizeWithFont:_serviceLabel.font];
    _serviceLabel.frame = CGRectMake(CGRectGetMaxX(_shareToLabel.frame), _shareBaseY, serviceSize.width, serviceSize.height);
    _serviceLabel.text = self.service.typeName;
    
    CGSize nameSize = [self.service.user.userName sizeWithFont:_nameLabel.font];
    _nameLabel.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - nameSize.width - 10, _shareBaseY, nameSize.width, nameSize.height);
    _nameLabel.text = self.service.user.userName;
}

-(void) updateWithImages {
    for (UIButton *button in _imageButtons) {
        [button removeFromSuperview];
    }
    
    [_imageButtons removeAllObjects];
    
    UIImage *selectImage = BWXPNGImage(@"image-photo-select",@"BWXShare.bundle");
    for (int i = 0;i < [_images count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((40+10) * i + 10, 10, 40, 40);
        [button setImage:selectImage forState:UIControlStateSelected];
        button.imageEdgeInsets = UIEdgeInsetsMake(-30, 0, 0, -30);
        button.adjustsImageWhenHighlighted = NO;
        [button addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchDown];
        UIImage *image = [_images objectAtIndex:i];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [_bottomView addSubview:button];
        [_imageButtons addObject:button];
    }
    
    if ([_images count] > 0) {
        _currentSelectImageIndex = 0;
        [[_imageButtons objectAtIndex:0] setSelected:YES];
    } else {
        _currentSelectImageIndex = NSNotFound;
    }

}

-(void) updateUserNameLabel {
    NSString *nameString = _service.user.userName;
    CGSize nameSize = [nameString sizeWithFont:_nameLabel.font];
    _nameLabel.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - nameSize.width - 10, _shareBaseY, nameSize.width, nameSize.height);
    _nameLabel.text = _service.user.userName;
}

-(void) updateCountLabel {
    _countLabel.text = [NSString stringWithFormat:@"%d",BWXShareViewControllerTextInputMaxSize - [_contentTextView.text length]];
}

-(void) updateWithContent {
    _contentTextView.text = _content;
    [self updateCountLabel];
    
}

-(void)setContent:(NSString *)content {
    if (_content != content) {
        [_content release];
        _content = [content retain];
        [self updateWithContent];
    }
}

-(NSString *)content {
    return _content;
}

-(void)setImages:(NSArray *)images {
    if (_images != images) {
        [_images release];
        if ([images count] > _maxNumberOfImages) {
            _images = [[images subarrayWithRange:NSMakeRange(0, _maxNumberOfImages)] retain];
        } else {
            _images = [images copy];
        }
        [self updateWithImages];
    }
}

-(NSArray *)images {
    return _images;
}

#pragma mark -UIResponder methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([_contentTextView isFirstResponder] && [touch view] != _contentTextView) {
        [_contentTextView resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - actions
-(void) leftBarButtonPressed:(id) sender {
//    [self.navigationController popViewControllerAnimated:YES];
    if (self.navigationController && self.navigationController.topViewController != self) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void) rightBarButtonPressed:(id) sender {
    
    if ([_content length] == 0) {
       UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"分享错误" message:@"文本内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
        [av show];
        return;
    }
    
    if ([_content length] > BWXShareViewControllerTextInputMaxSize) {
        UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"分享错误" message:@"文本过长" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
        [av show];
        return;
    }
    
    // TODO : 发送分享事件
    UIImage *image = nil;
    if (_currentSelectImageIndex != NSNotFound) {
        image = [_images objectAtIndex:_currentSelectImageIndex];
    }
    
    //hide keyboard
    [_contentTextView resignFirstResponder];
    
//    [[BWXShareProgress shareProgress] showLoadingWithMessage:@"分享中..."];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    hud.labelText = @"分享中...";
    hud.opacity = 0.6;
    hud.labelFont = [UIFont fontWithName:UU_CUSTOM_BODY_FONT size:16];
    
    [self.service shareImage:image withText:_content];
}

-(void) imageButtonPressed:(id) sender {
    for (int i = 0; i < [_imageButtons count]; i++) {
        UIButton *button = [_imageButtons objectAtIndex:i];
        if (button == sender) {
            [button setSelected:![button isSelected]];
            if (button.selected) {
                _currentSelectImageIndex = i;
            } else {
                _currentSelectImageIndex = NSNotFound;
            }
        } else {
            [button setSelected:NO];
        }
    }
}

#pragma mark - Text View Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    [self updateCountLabel];
    
    _contentTextView.selectedRange = NSMakeRange(textView.text.length, 0);
}

-(void)textViewDidChange:(UITextView *)textView {
    [_content release];
    _content = [textView.text copy];
    [self updateCountLabel];
    
    //TODO:关于字数限制还不确定怎么做。新浪和腾讯貌似不一
    
//    NSString *text = textView.text;
//    NSUInteger length = [text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    NSUInteger size = length/3;
//    NSLog(@"%d %d",length,size);
//    _countLabel.text = [NSString stringWithFormat:@"%d",BWXShareViewControllerTextInputMaxSize - size];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [_content release];
    _content = [textView.text copy];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"service.user.userName" isEqualToString:keyPath]&& [[change objectForKey:NSKeyValueChangeKindKey] intValue] == NSKeyValueChangeSetting) {
        [self updateUserNameLabel];
    }
}


@end
