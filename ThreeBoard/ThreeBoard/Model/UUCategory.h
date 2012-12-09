//
//  UUCategory.h
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUCategory : NSObject

@property (nonatomic, copy) NSString *categoryID;
@property (nonatomic, copy) NSString *categoryTitle;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray *focusPages;
@property (nonatomic, strong) NSMutableArray *listPages;
@property (nonatomic) BOOL hasmore;

@end
