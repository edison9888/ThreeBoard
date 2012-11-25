//
//  UUCategory.m
//  ThreeBoard
//
//  Created by garyliu on 12-11-24.
//  Copyright (c) 2012年 garyliu. All rights reserved.
//

#import "UUCategory.h"

@implementation UUCategory

@synthesize categoryID;
@synthesize categoryTitle;
@synthesize pageNo;
@synthesize focusPages;
@synthesize listPages;


- (id)init
{
    if(self = [super init]){
        self.focusPages = [NSMutableArray array];
        self.listPages = [NSMutableArray array];
    }
    return self;
}

@end
