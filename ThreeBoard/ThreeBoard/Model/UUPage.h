//
//  UUPage.h
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUPage : NSObject

@property (nonatomic, copy) NSString *pageID;
@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, strong) NSMutableArray *contents;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *thumbImageURL;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *categoryID;



@end
