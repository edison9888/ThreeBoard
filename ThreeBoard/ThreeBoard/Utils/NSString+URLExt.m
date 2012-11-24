//
//  NSString+JCUtilities
//
//  Created by Jerry Cheung on 12/20/10.
//  Copyright 2010 Jerry Cheung. All rights reserved.
//

#import "NSString+URLExt.h"


@implementation NSString(URLExt)

- (NSMutableDictionary*) queryStringDictionary {
  NSArray *elements = [self componentsSeparatedByString:@"&"];
  NSMutableDictionary *retval = [NSMutableDictionary dictionaryWithCapacity:[elements count]];
  for(NSString *e in elements) {
    NSArray *pair = [e componentsSeparatedByString:@"="];
    [retval setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
  }
  return retval;
}

+ (NSString *)encodedStringWithContentsOfURL:(NSURL *)url
{
    // Get the web page HTML
    NSData *data = [NSData dataWithContentsOfURL:url];
    
	// response
	int enc_arr[] = {
		NSUTF8StringEncoding,			// UTF-8
		NSShiftJISStringEncoding,		// Shift_JIS
		NSJapaneseEUCStringEncoding,	// EUC-JP
		NSISO2022JPStringEncoding,		// JIS
		NSUnicodeStringEncoding,		// Unicode
		NSASCIIStringEncoding			// ASCII
	};
    
	NSString *data_str = nil;
	int max = sizeof(enc_arr) / sizeof(enc_arr[0]);
	for (int i=0; i<max; i++) {
		data_str = [
                    [NSString alloc]
                    initWithData : data
                    encoding : enc_arr[i]
                    ];
		if (data_str!=nil) {
			break;
		}
	}
    return data_str;
	
}
@end
