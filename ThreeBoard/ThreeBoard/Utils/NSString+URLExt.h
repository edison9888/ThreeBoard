//
//  NSString+JCUtilities.h
//
//  Returns a dictionary of query string and fragment string parameters.
//  Example:
//  NSURL *url = [NSURL URLWithString:@"http://intridea.com/?foo=bar#baz=garply"];
//  [[url fragment] queryStringDictionary];  # { 'foo' = 'bar'; }
//  [[url query] queryStringDictionary];  # { 'baz' = 'garply'; }
//
//  Created by Jerry Cheung on 12/20/10.
//  Copyright 2010 Jerry Cheung. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString(URLExt)

- (NSMutableDictionary*) queryStringDictionary;
+ (NSString *)encodedStringWithContentsOfURL:(NSURL *)url;

@end