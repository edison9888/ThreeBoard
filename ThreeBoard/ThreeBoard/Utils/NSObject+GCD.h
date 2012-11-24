//
//  NSObject+GCD.h
//

//  Created by JHorn.Han on 10/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//


@interface NSObject (GCD)



- (void)performOnMainThread:(void(^)(void))block wait:(BOOL)wait;

- (void)performAsynchronous:(void(^)(void))block;

- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block;

- (void)performBlockInBackground:(void(^)(void))block afterDelay:(NSTimeInterval)delay;

- (void)performBlockOnMainThread:(void(^)(void))block afterDelay:(NSTimeInterval)delay;

- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay;
@end
