//
//  UUCategoryDataProvider.h
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUPage.h"
#import "UUCategory.h"
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"

@protocol UUCategoryDataProviderDelegate <NSObject>

@optional
- (void)categoryDetailFetched:(UUCategory *)categoryDetail;
- (void)categoryDetailFailed:(NSError *)error;
- (void)goodPolicyDetailFetched:(UUCategory *)category;
- (void)goodPolicyDetailFailed:(NSError *)error;
- (void)newInfoDetailFetched:(UUCategory *)category;
- (void)newInfoDetailFailed:(NSError *)error;
- (void)activityDetailFetched:(UUCategory *)category;
- (void)activityDetailFailed:(NSError *)error;
- (void)beijingAreaDetailFetched:(UUCategory *)category;
- (void)beijingAreaDetailFailed:(NSError *)error;
- (void)changjiangAreaDetailFetched:(UUCategory *)category;
- (void)changjiangAreaDetailFailed:(NSError *)error;
- (void)zhujiangAreaDetailFetched:(UUCategory *)category;
- (void)zhujiangAreaDetailFailed:(NSError *)error;
- (void)otherAreaDetailFetched:(UUCategory *)category;
- (void)otherAreaDetailFailed:(NSError *)error;
- (void)partnerDetailFetched:(UUCategory *)category;
- (void)partnerDetailFailed:(NSError *)error;

@end


@interface UUCategoryDataProvider : NSObject

@property (nonatomic, weak) id<UUCategoryDataProviderDelegate> delegate;

+ (UUCategoryDataProvider *)sharedInstance;
- (void)fetchBeijingAreaDetailWithPageIndex:(NSInteger)index;
- (void)fetchChangjiangAreaDetailWithPageIndex:(NSInteger)index;
- (void)fetchZhujiangAreaDetailWithPageIndex:(NSInteger)index;
- (void)fetchOtherAreaDetailWithPageIndex:(NSInteger)index;
- (void)fetchGoodPolicyDetailWithPageIndex:(NSInteger)index;
- (void)fetchNewInfoDetailWithPageIndex:(NSInteger)index;
- (void)fetchActivityDetailWithPageIndex:(NSInteger)index;
- (void)fetchPartnersDetailWithType:(NSInteger)type pageIndex:(NSInteger)index;

@end

