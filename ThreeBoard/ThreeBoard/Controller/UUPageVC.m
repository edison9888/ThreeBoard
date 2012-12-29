//
//  UUPageVC.m
//  ThreeBoard
//
//  Created by garyliu on 12-12-15.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUPageVC.h"
#import "UUWebView.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "AJNotificationView.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "BWXShareCenter.h"


@interface UUPageVC ()
{
    BOOL pageDidFinishLoad;
}

@property (nonatomic, strong) UUWebView *webview;
@property (nonatomic, copy) NSString *pageID;
@property (nonatomic, strong) UUPage *uuPage;
@property (nonatomic, strong) UIBarButtonItem *shareButton;
@property (nonatomic, copy) NSString *sharedContent;

- (void)imageCacheFinished:(NSNotification *)notification;
- (void)shareButtonClicked:(id)sender;
- (UIImage *)imageFromText:(NSString *)text;

@end

@implementation UUPageVC

@synthesize webview;
@synthesize pageID;
@synthesize uuPage;
@synthesize shareButton;
@synthesize sharedContent;

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
    self.webview = [[UUWebView alloc] initWithFrame:self.view.frame];
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
    pageDidFinishLoad = NO;
    
    self.shareButton = [UUUIHelper createNormalBarButtonItemWithTitle:@"分享" position:CGPointMake(0, 0) target:self selector:@selector(shareButtonClicked:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    UIFont *font = [UIFont fontWithName:UU_CUSTOM_BODY_FONT size:11];
    CGSize size  = [text sizeWithFont:font constrainedToSize:CGSizeMake(320, 5000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    else
        // iOS is < 4.0
        UIGraphicsBeginImageContext(size);
    
    CGContextSetFillColor(UIGraphicsGetCurrentContext(), CGColorGetComponents([UIColor colorWithHexString:@"f1f1f1"].CGColor));
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width,size.height));
    CGContextSetFillColor(UIGraphicsGetCurrentContext(), CGColorGetComponents([UIColor blackColor].CGColor));
    [text drawInRect:CGRectMake(0, 0, size.width, size.height) withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)shareButtonClicked:(id)sender
{


    if(pageDidFinishLoad){
        NSString *sharedText = [NSString stringWithFormat:@"好文分享：\"%@\"。来自淘金新三板iPhone客户端。",self.uuPage.pageTitle];
        [BWXShareCenterInstance singleShareImage:[NSArray arrayWithObject:[self imageFromText:self.sharedContent]] content:sharedText withController:self.navigationController];
    }
    
}

#pragma mark - UUWebViewDelegate methods

- (void)webViewDidFinishLoad:(UUWebView *)webView
{
    [UUPageDataProvider sharedInstance].delegate = self;
    [[UUPageDataProvider sharedInstance] fetchPageInfoWithID:self.pageID];
}

- (void)webView:(UUWebView *)webView didFailLoadWithError:(NSError *)error
{
    
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
        self.sharedContent = [NSString stringWithFormat:@"    %@\n",page.pageTitle];
//        [jsonDict setObject:@"www.baidu.com" forKey:@"url"];
        [jsonDict setObject:page.pageID forKey:@"nid"];
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
                
                self.sharedContent = [self.sharedContent stringByAppendingFormat:@"    %@\n",alteredContent];
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
        
        pageDidFinishLoad = YES;
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
    
    pageDidFinishLoad = NO;
}

#pragma mark  SDWebImageDownloaderDelegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url
{

    
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url
{
    
}



@end
