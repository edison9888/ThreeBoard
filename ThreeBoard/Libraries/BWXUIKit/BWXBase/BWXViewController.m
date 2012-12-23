//
//  BWXNaviigationViewController.m
//  WXUIKit
//
//  Created by Daly Dai on 12-7-13.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "BWXViewController.h"
#import "BWXUIKit.h"

static UIImage *UINavigationBarCustomBackgroundImage;
@implementation UINavigationBar(CustomBackground)
+ (void)setCustomBackgroundImage:(UIImage*)image andIfCover:(BOOL)flag{
    if (!UINavigationBarCustomBackgroundImage || flag) {
        [UINavigationBarCustomBackgroundImage release];
    }   UINavigationBarCustomBackgroundImage = [image retain];
}

- (void)drawRect:(CGRect)rect {
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 5) {
		[super drawRect:rect];
	} else {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
        [UINavigationBarCustomBackgroundImage drawAsPatternInRect:rect];
		CGContextRestoreGState(ctx);
	}
}

@end



@interface BWXViewController ()
{
    UIImage *nBackImage;
    UIImage *hBackImage;
    UIImage *iBackImage;
    
    UIImage *_navigationBarBgImage;
}
- (void)setBackTitle:(NSString *)backTitle;
@end

@implementation BWXViewController
@synthesize navigationBarBgImage = _navigationBarBgImage;
@synthesize autorotate;
@synthesize bundlePath;

- (id)init
{
    self = [super init];
    if (self) {
        self.autorotate = YES;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRotate) name:kScreenRotate object:nil];

    }
    return self;
}

- (void)loadView
{
    [super loadView];
    //给navigationBar添加背景图
    if (!self.navigationBarBgImage) {
        self.navigationBarBgImage = BWXPNGImage(@"bg_nav", @"BWXBase.bundle");
    }

    // 导航按钮
    NSArray *controllers = [self.navigationController viewControllers];
    if ([controllers count] > 1) {
        [self setBackTitle:@"返回"];
    }
}

- (void)onRotate
{
    //if subview want respond page rotate ,should implemented
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return self.autorotate;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSNotificationCenter* notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:kScreenRotate object:nil userInfo:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationBarBgImage = nil;
    [super dealloc];
}



- (void)setBackButtonWithNormalImage:(UIImage*)nImage HighlightedImage:(UIImage*)hImage andBackIcon:(UIImage*)iImage
{  
    [nBackImage release]; nBackImage = [nImage retain];
    [hBackImage release]; hBackImage = [hImage retain];
    [iBackImage release]; iBackImage = [iImage retain];
}

#pragma mark - public function

- (void)setBackTitle:(NSString *)backTitle
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	if ([backTitle length] > 2) {
		[backButton setFrame:CGRectMake(0, 0, 55, 33)];
	} else {
		[backButton setFrame:CGRectMake(0, 0, 55, 33)];
	}
    UIImage *img0 = [BWXPNGImage(@"bg_navbtn_back_normal",@"BWXBase.bundle") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImage *img1 = [BWXPNGImage(@"bg_navbtn_back_select",@"BWXBase.bundle") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [backButton setBackgroundImage:img0 forState:UIControlStateNormal];
    [backButton setBackgroundImage:img1 forState:UIControlStateHighlighted];
    
    backButton.titleLabel.font = BWXFontWithSize(13);
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[backButton setTitle:backTitle forState:UIControlStateNormal];
	[backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
	[backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = backButtonItem;
	self.navigationItem.backBarButtonItem = nil;
	[backButtonItem release];
}

- (void)back:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)setNavigationBarBgImage:(UIImage *)navigationBarBgImage {
    if (_navigationBarBgImage != navigationBarBgImage) {
        [_navigationBarBgImage release];
        _navigationBarBgImage = [navigationBarBgImage retain];
        if ([[[UIDevice currentDevice] systemVersion] intValue] >= 5) {
            [self.navigationController.navigationBar setBackgroundImage:self.navigationBarBgImage
                                                          forBarMetrics:UIBarMetricsDefault];
        } else {
            [UINavigationBar setCustomBackgroundImage:self.navigationBarBgImage andIfCover:NO];
            [self.navigationController.navigationBar setNeedsDisplay];
        }
    }
}

@end

