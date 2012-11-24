//
//  UIDevice(Identifier).h
//  UIDeviceAddition
//
//  Created by Jhorn Han Kitz on 20.08.11.
//  Copyright 2011 baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice (IdentifierAddition)

// appBundle + mac  MD5
- (NSString *) uniqueDeviceIdentifier;


// MAC has MD5
- (NSString *) uniqueGlobalDeviceIdentifier;

@end
