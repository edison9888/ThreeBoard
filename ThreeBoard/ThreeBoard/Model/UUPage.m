//
//  UUPage.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUPage.h"

@implementation UUPage

@synthesize  pageID;
@synthesize pageTitle;
@synthesize summary;
@synthesize contents;
@synthesize imageURL;
@synthesize thumbImageURL;
@synthesize publishTime;
@synthesize categoryID;


- (id)init
{
    if(self = [super init]){
        self.contents = [NSMutableArray array];
        self.pageID = @"";
        self.pageTitle = @"";
        self.summary = @"";
        self.imageURL = @"";
        self.thumbImageURL = @"";
        self.publishTime = @"";
    }
    return self;
}


@end
