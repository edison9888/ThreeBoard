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

@interface UUPageVC ()

@property (nonatomic, strong) SNWebView *webview;
@property (nonatomic, strong) NSString *pageID;

@end

@implementation UUPageVC

@synthesize webview;
@synthesize pageID;


- (id)initWithPageID:(NSString *)_pageID
{
    self = [super init];
    if(self){
        self.pageID = _pageID;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    self.view.backgroundColor = UU_BG_WHITE;
    self.webview = [[SNWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webview];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UUPageDataProvider sharedInstance].delegate = self;
    [[UUPageDataProvider sharedInstance] fetchPageInfoWithID:self.pageID];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [MBProgressHUD HUDForView:self.view].labelText = @"载入中...";
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UUPageDataProvider sharedInstance].delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UUPageDataProvider delegate methods
- (void)pageInfoFetched:(UUPage *)page
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if([page.pageID isEqualToString:self.pageID]){
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
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
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
    NSString *imageURLStr = [url absoluteString];
    NSString *cachedImagePath = [[SDImageCache sharedImageCache] cachePathForKey:imageURLStr];
    
//    cachedImagePath = [[NSURL fileURLWithPath:cachedImagePath] absoluteString];
    
    NSDictionary *imageDic = [NSDictionary dictionaryWithObjectsAndKeys:cachedImagePath,@"localPath",imageURLStr,@"imageUrl", nil];
    NSArray *imageArray = [NSArray arrayWithObjects:imageDic, nil];
    [self.webview notifyImages:[imageArray JSONString]];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url
{
    
}



@end
