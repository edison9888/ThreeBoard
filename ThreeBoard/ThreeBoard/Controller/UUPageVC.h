//
//  UUPageVC.h
//  ThreeBoard
//
//  Created by garyliu on 12-12-15.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUPageDataProvider.h"
#import "SDWebImageManagerDelegate.h"
#import "UUWebView.h"

@interface UUPageVC : UIViewController <UUPageDataProviderDelegate,SDWebImageManagerDelegate,UUWebViewDelegate>

- (id)initWithPageID:(NSString *)_pageID;

@end
