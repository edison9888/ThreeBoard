//
//  UUPageVC.m
//  ThreeBoard
//
//  Created by garyliu on 12-12-15.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUPageVC.h"
#import "SNWebView.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "AJNotificationView.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "BWXShareCenter.h"


@interface UUPageVC ()

@property (nonatomic, strong) SNWebView *webview;
@property (nonatomic, strong) NSString *pageID;
@property (nonatomic, strong) UUPage *uuPage;
@property (nonatomic, strong) UIBarButtonItem *shareButton;

- (void)imageCacheFinished:(NSNotification *)notification;
- (void)shareButtonClicked:(id)sender;
-(UIImage *)addText:(UIImage *)img text:(NSString *)text1;

@end

@implementation UUPageVC

@synthesize webview;
@synthesize pageID;
@synthesize uuPage;
@synthesize shareButton;

- (id)initWithPageID:(NSString *)_pageID
{
    self = [super init];
    if(self){
        self.pageID = _pageID;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageCacheFinished:) name:SDWebImageCacheFinishedNotification object:nil];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64)];
    self.view.backgroundColor = UU_BG_WHITE;
    self.webview = [[SNWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webview];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shareButton = [UUUIHelper createNormalBarButtonItemWithTitle:@"分享" position:CGPointMake(0, 0) target:self selector:@selector(shareButtonClicked:)];
    
    [UUPageDataProvider sharedInstance].delegate = self;
    [[UUPageDataProvider sharedInstance] fetchPageInfoWithID:self.pageID];
    
    [UUProgressHUD showProgressHUDForView:self.view];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setRightBarButtonItem:self.shareButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UUPageDataProvider sharedInstance].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SDWebImageCacheFinishedNotification object:nil];
    self.navigationItem.rightBarButtonItem = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - private methods

-(UIImage *)addText:(UIImage *)img text:(NSString *)text1{
    int w = img.size.width;
    int h = img.size.height;
    //lon = h - lon;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
	
    char* text	= (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];// "05/05/09";
    CGContextSelectFont(context, "Arial", 18, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
	
    
    //rotate text
    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
	
    CGContextShowTextAtPoint(context, 4, 52, text, strlen(text));
	
	
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
    return [UIImage imageWithCGImage:imageMasked];
}

- (void)imageCacheFinished:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *imageURLStr = [userInfo objectForKey:@"key"];
    
    if([self.uuPage.imageURL isEqualToString:imageURLStr]){
        
        NSString *cachedImagePath = [[SDImageCache sharedImageCache] cachePathForKey:imageURLStr];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:cachedImagePath]){
            NSDictionary *imageDic = [NSDictionary dictionaryWithObjectsAndKeys:cachedImagePath,@"localPath",imageURLStr,@"imageUrl", nil];
            NSArray *imageArray = [NSArray arrayWithObjects:imageDic, nil];
            [self.webview notifyImages:[imageArray JSONString]];
        }
        
    }
}

-(UIImage *)imageFromText:(NSString *)text
{
    // set the font type and size
    UIFont *font = [UIFont systemFontOfSize:20.0];
    CGSize size  = [text sizeWithFont:font];
    
    // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    else
        // iOS is < 4.0
        UIGraphicsBeginImageContext(size);
    
    // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger
    //
    // CGContextRef ctx = UIGraphicsGetCurrentContext();
    // CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
    
    // draw in context, you can use also drawInRect:withFont:
    [text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)shareButtonClicked:(id)sender
{

//    NSString *cachedImagePath = [[SDImageCache sharedImageCache] cachePathForKey:self.uuPage.imageURL];
//    UIImage *sharedImage = [UIImage imageWithContentsOfFile:cachedImagePath];
    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
//    UIImage *sharedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self addText:sharedImage text:@"Hello world"];
    
    [BWXShareCenterInstance singleShareImage:[NSArray arrayWithObject:[self imageFromText:@"44332211"]] content:@"123123123123123" withController:self.navigationController];
}

#pragma mark - UUPageDataProvider delegate methods
- (void)pageInfoFetched:(UUPage *)page
{
    [UUProgressHUD hideProgressHUDForView:self.view];
    
    if([page.pageID isEqualToString:self.pageID]){
        self.uuPage = page;
        
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        
        [jsonDict setObject:page.publishTime forKey:@"ts"];
        [jsonDict setObject:page.pageTitle forKey:@"title"];
        [jsonDict setObject:@"www.baidu.com" forKey:@"url"];
        [jsonDict setObject:page.pageID forKey:@"nid"];
//        [jsonDict setObject:@"这里是摘要" forKey:@"abs"];
//        [jsonDict setObject:@"来源：" forKey:@"site"];
//        [jsonDict setObject:@"发布者：" forKey:@"category"];
//        [jsonDict setObject:@"" forKey:@"type"];
//        [jsonDict setObject:[NSArray arrayWithObjects:page.imageURL, nil] forKey:@"imageurls"];
        NSMutableArray *arrContent = [NSMutableArray array];
        
        //add images if there are any
        if(page.imageURL && ![page.imageURL isEqualToString:@""]){
            NSDictionary *smallImageDict = [NSDictionary dictionaryWithObjectsAndKeys:page.imageURL,@"url",@"480",@"width",@"270",@"height", nil];
            NSDictionary *imagesDict = [NSDictionary dictionaryWithObjectsAndKeys:smallImageDict,@"small", nil];
            NSDictionary *imageTypeDict = [NSDictionary dictionaryWithObjectsAndKeys:imagesDict,@"data",@"image",@"type", nil];
            [arrContent addObject:imageTypeDict];
        }
        
        //add text paragraphs
        for(NSString *content in page.contents){
            NSString *alteredContent = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(![alteredContent isEqualToString:@""]){
                NSDictionary *dicContent = [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"type",content,@"data", nil];
                [arrContent addObject:dicContent];
            }
        }
        
        //set content to webview
        [jsonDict setObject:arrContent forKey:@"content"];
        NSString *jsonStr = [jsonDict JSONString];
        [self.webview notifyNews:jsonStr];
        
        //set image to webview
        if(page.imageURL && ![page.imageURL isEqualToString:@""]){
            NSString *cachedImagePath = [[SDImageCache sharedImageCache] cachePathForKey:page.imageURL];
            if([[NSFileManager defaultManager] fileExistsAtPath:cachedImagePath]){
                NSDictionary *imageDic = [NSDictionary dictionaryWithObjectsAndKeys:cachedImagePath,@"localPath",page.imageURL,@"imageUrl", nil];
                NSArray *imageArray = [NSArray arrayWithObjects:imageDic, nil];
                [self.webview notifyImages:[imageArray JSONString]];
            }else{
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager cancelForDelegate:self];
                [manager downloadWithURL:[NSURL URLWithString:page.imageURL] delegate:self];
            }
        }
    }
}

- (void)pageInfoFailed:(NSError *)error
{
    [UUProgressHUD hideProgressHUDForView:self.view];
    
    
    //notify user
    [AJNotificationView showNoticeInView:self.navigationController.view
                                    type:AJNotificationTypeRed
                                   title:@"联网失败，请重试"
                         linedBackground:AJLinedBackgroundTypeStatic
                               hideAfter:1.0f
                                  offset:65.0f];
}

#pragma mark  SDWebImageDownloaderDelegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url
{

    
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url
{
    
}



@end
