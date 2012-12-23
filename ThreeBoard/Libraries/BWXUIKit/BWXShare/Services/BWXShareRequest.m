//
//  BWXShareRequest.m
//  CoreShare
//
//  Created by Daly on 12-11-26.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "BWXShareRequest.h"
#import "BWXShareRequest.h"
@implementation BWXShareRequest


+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    if (![httpMethod isEqualToString:@"GET"])
    {
        return baseURL;
    }
    
    NSURL *parsedURL = [NSURL URLWithString:baseURL];
	NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString *query = [BWXShareRequest stringFromDictionary:params];
	
	return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

#pragma mark - Private Methods

+ (NSString *)stringFromDictionary:(NSDictionary *)dict
{
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator])
	{
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
		{
			continue;
		}
		
        NSString *urlString = (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[[dict objectForKey:key] mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlString]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}
@end





