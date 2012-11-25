//
//  UUPageDataProvider.h
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUPage.h"
#import "UUCategory.h"

@protocol UUPageDataProviderDelegate <NSObject>

- (void)pageInfoFetched:(UUPage *)page;
- (void)pageInfoFailed:(NSError *)error;

@end


@interface UUPageDataProvider : NSObject

@property (nonatomic, weak) id<UUPageDataProviderDelegate> delegate;

+ (UUPageDataProvider *)sharedInstance;
- (void)fetchPageInfoWithID:(NSString *)pageID;

@end
