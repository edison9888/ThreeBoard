/*
 *  Utilities.m
 *  DailyPointWatch
 *
 *  Created by Gary Morris on 9/12/09.
 *  Copyright 2009 Gary A. Morris. All rights reserved.
 *
 */

#include "Utilities.h"
#include <sys/types.h> 
#include <sys/sysctl.h> 
#import "mach/mach.h"

#ifdef FLURRYAPI
#import "FlurryAPI.h"
#endif

@implementation Utilities

+(BOOL) use24HourClock
{
	BOOL using24HourClock = NO;

#define USE_MY_ORIGINAL_CODE
	
#ifdef USE_MY_ORIGINAL_CODE
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];	
	[dateFormatter setLocale: [NSLocale currentLocale]];	
	[dateFormatter setDateStyle:kCFDateFormatterNoStyle];
	[dateFormatter setTimeStyle:kCFDateFormatterShortStyle];	
	NSDate* midnight = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:0];   // get date/time (1Jan2001 0000UTC)
	NSString* dateString = [dateFormatter stringFromDate: midnight];
	// dateString will either be "15:00" or "16:00" (depending on DST) or
	// it will be "4:00 PM" or "3:00 PM" (depending on DST)
	using24HourClock = ([dateString length] <= 5);
	[midnight release];
	[dateFormatter release];	
#endif
	
#ifdef USE_ANSWER_FROM_MADHUP
	NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:kCFDateFormatterMediumStyle];	
	NSDate* midnight = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:0];   // get date/time (1Jan2001 0000UTC)
	NSString *timeStr = [dateForm stringFromDate:midnight];
	NSRange range = [timeStr rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
	// if no space, it's a 24 hr clock, except what if time is "23:59:59pm"?
	using24HourClock = range.location == NSNotFound;	
	[dateForm release];
#endif
	
	return using24HourClock;
}

//============================================================================
// Given a date/time, returns NSDate for the specified time on that same day
//============================================================================
+(NSDate*) dateFromDate:(NSDate*)fromDate 
			   withHour:(NSInteger)hour 
				 Minute:(NSInteger)min 
				 Second:(NSInteger)sec
{
	NSCalendar* curCalendar = [NSCalendar currentCalendar];
	const unsigned units    = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents* comps = [curCalendar components:units fromDate:fromDate];
	[comps setHour:   hour];
	[comps setMinute: min];
	[comps setSecond: sec];
	
	return [curCalendar dateFromComponents:comps];
}

//============================================================================
// Given a date/time, returns NSDate for the specified time on that same day
//============================================================================
+(NSDate*) dateFromDate:(NSDate*)fromDate 
			 withMinute:(NSInteger)min 
				 Second:(NSInteger)sec
{
	NSCalendar* curCalendar = [NSCalendar currentCalendar];
	const unsigned units    = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit;
	NSDateComponents* comps = [curCalendar components:units fromDate:fromDate];
	[comps setMinute: min];
	[comps setSecond: sec];
	
	return [curCalendar dateFromComponents:comps];
}

//============================================================================
// Given a date/time, returns NSDate for the specified time on that same day
//============================================================================
+(NSDate*) dateFromDate:(NSDate*)fromDate 
			 withSecond:(NSInteger)sec
{
	NSCalendar* curCalendar = [NSCalendar currentCalendar];
	const unsigned units    = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
	NSDateComponents* comps = [curCalendar components:units fromDate:fromDate];
	[comps setSecond: sec];
	
	return [curCalendar dateFromComponents:comps];
}

//============================================================================
// returns NSDate for the specified y/m/d/h/m/s using current calendar
//============================================================================
+(NSDate*) dateWithYear:(NSInteger)year
				  Month:(NSInteger)month
					Day:(NSInteger)day
				   Hour:(NSInteger)hour
				 Minute:(NSInteger)min 
				 Second:(NSInteger)sec
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:   year];
	[comps setMonth:  month];
	[comps setHour:   hour];
	[comps setDay:    day];
	[comps setMinute: min];
	[comps setSecond: sec];
	
	NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
	[comps release];
	
	return date;
}

//============================================================================
// Given a date/time, return the NSDate for a date X days in the future
// (if daysOffset > 0) or X days in the past (if daysOffset < 0)
//============================================================================
+(NSDate*) getRelativeDate:(NSDate*)fromDate DaysOffset:(int)daysOffset
{
    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:daysOffset];
    
    // get the calendar
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    // add the days offset to the date
    NSDate* result = [cal dateByAddingComponents:components toDate:fromDate options:0];
    
    [components release];
    return result;

}

//============================================================================
// Given a date/time, return the NSDate for midnight on the starting day
// of the week, given the day of the week that the week starts on.
//
// ie: fromDate="Tue 2009-11-03", startWeekday="Mon", returns "Mon 2009-11-02"
//     fromDate="Tue 2009-11-03", startWeekday="Tue", returns "Tue 2009-11-03"
//     fromDate="Tue 2009-11-03", startWeekday="Wed", returns "Wed 2009-10-28"
//
// startingWeekday is 0..6 where 0=Sunday, 6=Saturday
//============================================================================
+(NSDate*) getStartOfWeek:(NSDate*)fromDate StartingWeekday:(int)startWeekday
{
	NSDate* weekStartDate = [[[NSDate alloc] init] autorelease];
	
#if TARGET_OS_IPHONE
#ifndef NS_BLOCK_ASSERTIONS
	[Utilities notImplementedYet:@"getStartOfWeek"];
#endif
#endif
    
	return weekStartDate;
}

//----------------------------------------------------------------------------
// extracts hour/minutes from NSDate, converts to MinuteOfTheDay
//----------------------------------------------------------------------------
+(MinuteOfTheDay) getMinuteOfTheDay:(NSDate*)time
{
	NSCalendar* curCalendar = [NSCalendar currentCalendar];
	const unsigned units    = NSHourCalendarUnit | NSMinuteCalendarUnit;
	NSDateComponents* comps = [curCalendar components:units fromDate:time];
	NSInteger hour = [comps hour];
	NSInteger min  = [comps minute];

	return (hour * 60) + min;
}

//============================================================================
// Constrains a value to be within a range.  
// IF the value given is less than the min THEN min is returned, 
// ELSIF the value given is greater than the max THEN max is returned, 
// ELSE the value is returned
//============================================================================
+(long)constrain:(long)value min:(long)min max:(long)max {
	long result = value;
	if (result > max) {
		// value is above the maximum, replace with max
		result = max;
	} else if (result < min) {
		// value is below the minimum, replace with min
		result = min;
	}
	return result;
}

//============================================================================
// The oldValue given is replaced by the input value but only if the
// input value is not a null string.  If the input value is a null string
// then the oldValue is returned.
//============================================================================
+(long)filterNullString:(NSString*)input oldValue:(long)oldValue {
	if ([input length] == 0) {
		return oldValue;
	} else {
		return [input intValue];
	}
}

//-----------------------------------------------------------------------------
// adds spaces to pad string length to desired length
// spaces are evenly divided between left and right side to center the string
// returns the string unchanged if no padding needed, otherwise
// it returns an autoreleased string.
//-----------------------------------------------------------------------------
+(NSString*)centerStringWithPadding:(NSString*)str Length:(int)len
{
	if ([str length] >= len) return [NSString stringWithString:str];	// return a copy
	
	// insert spaces before and after to pad it up to length characters
	unsigned nSpaces = (unsigned) (len - [str length]);	
	unsigned rSpaces = nSpaces / 2;		// truncates if odd number
	unsigned lSpaces = nSpaces - rSpaces;
	if (rSpaces+1 == lSpaces) rSpaces++;	// balance odd number
	
	NSMutableString* newStr = [[[NSMutableString alloc] init] autorelease];
	if (lSpaces > 0) [newStr appendFormat:@"%*s", lSpaces, " "];
	[newStr appendString:str];
	if (rSpaces > 0) [newStr appendFormat:@"%*s", rSpaces, " "];
	
	return newStr;
}

#if TARGET_OS_IPHONE
+(void)showMessage:(NSString*)message title:(NSString*)title
{
	NSLog(@"%@ %@", title, message);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message 
						  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+(id)loadNib:(NSString*)nibName ClassName:(NSString*)className Owner:(id)owner
{
	id obj = nil;
	Class theClass = NSClassFromString(className);
	
	NSArray* nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
	for (id anObject in nib) {
		if ([anObject isKindOfClass:theClass]) {
			obj = anObject;
			break;
		}
	}	

	return obj;
}

size_t sizeofUIImage(UIImage* image) {
    return CGImageGetBytesPerRow(image.CGImage) * CGImageGetHeight(image.CGImage);
}
#endif

vm_size_t usedMemory(void) {
	struct task_basic_info info;
	mach_msg_type_number_t size = sizeof(info);
	kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
	return (kerr == KERN_SUCCESS) ? info.resident_size : 0;   // size in bytes
}

#if 0
vm_size_t usedMemory(void) {
	struct task_basic_info info;
	mach_msg_type_number_t size = sizeof(info);
	kern_return_t kerr = task_info(mach_task_self(),
								   TASK_BASIC_INFO,
								   (task_info_t)&info,
								   &size);
	if( kerr == KERN_SUCCESS ) {
		return info.resident_size; //in bytes
	}
	return 0;
}
#endif

vm_size_t freeMemory(void) {
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t              pagesize;
    vm_statistics_data_t   vm_stat;
	
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);	
    return vm_stat.free_count * pagesize;
}


void logMemUsage(void) {
	// compute memory usage and log if different by >= 100k
	static long prevMemUsage = 0;
	long curMemUsage = usedMemory();
	long memUsageDiff = curMemUsage - prevMemUsage;

	if (memUsageDiff > 100000 || memUsageDiff < -100000) {
		prevMemUsage = curMemUsage;
		NSLog(@"Memory used %7.1f (%+5.0f), free %7.1f kb", 
			  curMemUsage/1000.0f, 
			  memUsageDiff/1000.0f, 
			  freeMemory()/1000.0f);
	}
}

#if TARGET_OS_IPHONE
//-----------------------------------------------------------------------------
// Checks the value to see if it is between min..max, if so no alert is
// displayed and the value is returned unchanged.
// If the value is > max or < min, then it displays an alert saying that
// <thingName> is too much or too low and returns the min or max value
//-----------------------------------------------------------------------------
+(long)checkRangeAndAlert:(NSString*)thingName value:(long)value min:(long)min max:(long)max
{
	long tmpValue = value;
	NSString *msg = nil;
	
	if (tmpValue > max) {
		// Value is too high, display an alert explaining and replace value with the maximim
		msg = [[NSString alloc] initWithFormat: @"%ld %@ is too much, the maximum is %ld", tmpValue, thingName, max]; 
		tmpValue = max;
		
	} else if (tmpValue < min) {
		// Value is too low, display an alert explaining and replace value with the minimum
		msg = [[NSString alloc] initWithFormat: @"%ld %@ is too low, the minimum is %ld", tmpValue, thingName, min]; 
		tmpValue = min;
	}
	
	if (msg != nil) {
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"Value Out of Range" 
							  message:msg 
							  delegate:self 
							  cancelButtonTitle:@"OK" 
							  otherButtonTitles:nil]; 
		[alert show]; 
		[alert release]; 
		[msg release]; 
	}
	
	return tmpValue;
}

#ifndef NS_BLOCK_ASSERTIONS
+(void)notImplementedYet:(NSString*)what
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Not Implemented Yet" 
						  message:what 
						  delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil]; 
	[alert show]; 
	[alert release]; 
}
#endif

//----------------------------------------------------------------------
// returns YES if multitasking is available (iOS 4.0 or >)
//----------------------------------------------------------------------
BOOL hasMultitasking() 
{
	UIDevice* device = [UIDevice currentDevice];
	if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
		return [device isMultitaskingSupported];
	}
	return NO;
}
#endif

//----------------------------------------------------------------------
// returns the fullpath of the app's Documents folder
//----------------------------------------------------------------------
NSString* documentsPath()
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	return [paths objectAtIndex:0]; 
}

NSString* randNameByTime()
{
    NSDate* date = [NSDate date];
    NSTimeInterval timeofInt = [date timeIntervalSince1970];
    NSString* str = [NSString stringWithFormat:@"%f",timeofInt];
    return str;
}

//----------------------------------------------------------------------
// prints list of files w/NSLog
// pass nil for directory param to get list of Documents folder
//----------------------------------------------------------------------
void listFiles(NSString* directory)
{
	if (directory == nil) {
		directory = documentsPath();
	}
	NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* filenames = [fileMgr contentsOfDirectoryAtPath:directory error:NULL];
	NSDateFormatter* dateFmtr = [NSDateFormatter new];
	[dateFmtr setDateFormat:@"yyyy-MM-dd HH:mm"];
	
	NSLog(@"%u files in %@", (unsigned)[filenames count], directory);
	
	[fileMgr changeCurrentDirectoryPath:directory];
	
    for (NSString* filename in filenames){
		NSDictionary* dict = [fileMgr attributesOfItemAtPath:filename error:NULL];
		NSUInteger perms  = [dict filePosixPermissions];
		NSString* owner = [dict fileOwnerAccountName];
		NSString* group = [dict fileGroupOwnerAccountName];
		uint64_t size   = [dict fileSize];
		NSDate* date    = [dict fileModificationDate];
		
        NSLog(@"File: %03u %@ %@ %6qu %@ %@", 
			  (unsigned)perms, owner, group, size, [dateFmtr stringFromDate:date], filename);
    }
    
    [dateFmtr release];
}

//----------------------------------------------------------------------
// returns YES if the URL is a file scheme URL and the path to the
// file is in the app's Documents folder.
//----------------------------------------------------------------------
BOOL isFileInDocuments(NSURL* fileURL)
{
	BOOL result = NO;
	
	if ([fileURL isFileURL]) {
		// Extract the fullpath from the fileURL to see if it matches Documents path
		NSString* dirOnly = [[[fileURL standardizedURL] path] stringByDeletingLastPathComponent];
		
		// compute the path to the documents folder
		result = [dirOnly isEqualToString:documentsPath()];
	}
	
	return result;
}

//----------------------------------------------------------------------
// logs the event to the FlurryAPI 
// (or to NSLog if in development)
//----------------------------------------------------------------------
void logEvent(NSString* description) 
{
#ifdef FLURRYAPI
	// count/log events using the FlurryAPI
	[FlurryAPI logEvent:description];
#else
	NSLog(@"logEvent: %@", description);
#endif		
}

//----------------------------------------------------------------------------
// fourBitsFromHexChar
//    input: '0'..'9','A'..'F' (or 'a'..'f')
//    output: 0..15
//----------------------------------------------------------------------------
uint8_t fourBitsFromHexChar(char hexChar) {
    if (hexChar >= 'A' && hexChar <= 'F') {
        return hexChar - 'A' + 10;
    } else if (hexChar >= 'a' && hexChar <= 'f') {
        return hexChar - 'a' + 10;
    }
    return (hexChar - '0') & 0xF;   // assume isdigit
}

//----------------------------------------------------------------------------
// charFromFourBits - input: 0..15, output: '0'..'9','A'..'F'
//----------------------------------------------------------------------------
char charFromFourBits(uint8_t fourBits) {
    if (fourBits <= 9) {
        return '0' + fourBits;
    } else {
        return 'A' + (fourBits - 10);
    }
}

//----------------------------------------------------------------------------
// uByteFrom2HexChars
//----------------------------------------------------------------------------
uint8_t uByteFrom2HexChars(const char* chars)
{
    return fourBitsFromHexChar(chars[0])*16 + fourBitsFromHexChar(chars[1]);    
}

//----------------------------------------------------------------------------
// GMLog -- same as NSLog but without the date/time/process id stuff
//----------------------------------------------------------------------------
void GMLog(NSString *format, ...)
{
    va_list args;    
    va_start (args, format);
    
    NSString* string = [[NSString alloc] initWithFormat:format  arguments:args];
    
    va_end (args);
    
    fprintf (stderr, "%s\n", [string UTF8String]);
    
    [string release];
}


+(NSString*)dateStringFrom:(NSTimeInterval)time
{
    NSTimeInterval times = time;
    NSDate* data = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease]; 
    [outputFormatter setLocale:[NSLocale currentLocale]];
    //[outputFormatter setDateFormat:@"yyyyMMdd HHmmSS"];
    [outputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    //	[outputFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate* inputDate = data;
    
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString*  stroutPutEnd = [outputFormatter stringFromDate:inputDate];
    return stroutPutEnd;
}

+(CGSize)stringSizeInContentRect:(CGSize)toSize 
                   stringContent:(NSString*)strContent
                            font:(UIFont*)font
                   lineBreakMode:(UILineBreakMode)lineBreadkMode
                      offsetSize:(CGPoint)sizeOffset;
{
    CGSize sizeOfStrContent = [strContent sizeWithFont:font 
                                     constrainedToSize:toSize
                                         lineBreakMode:lineBreadkMode];
    CGSize ss = CGSizeMake(sizeOfStrContent.width + sizeOffset.x,
                           sizeOfStrContent.height+sizeOffset.y);
    return ss;

}

+(NSString*)replaceFirstNewLine:(NSString *) original
{
    NSMutableString * newString = [NSMutableString stringWithString:original];
    
    NSRange foundRange = [original rangeOfString:@"\n"];
    if (foundRange.location != NSNotFound)
    {
        [newString replaceCharactersInRange:foundRange
                                 withString:@""];
    }
    
    return [[newString retain] autorelease];
}

+(NSString*)hasNewtext:(NSString*)textData
{
    if(textData == nil)
    {
        return nil;
    }
    
    NSString* strObj = textData;
    NSString *temptext = [strObj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *text = [temptext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    id parts = [NSMutableArray arrayWithArray:[text componentsSeparatedByString:@"\\n"]];
    [parts removeObject:@""]; // that's the empty string
    NSString *newString = [parts componentsJoinedByString:@""];
    if(newString == nil || [newString length] <= 0)
    {
        return nil;
    }
    
    return newString;
    //obj = newString;
}

+(void)doAnimationWithZoom:(UIView*)view inFactor:(CGFloat)zoomIn outFactor:(CGFloat)zoomOut interval:(CGFloat)timeInterval{
    
    [UIView animateWithDuration:timeInterval
     
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                         view.transform = CGAffineTransformMakeScale(zoomIn, zoomIn);  
                         
                     }completion:^(BOOL finish){
                         
                         [UIView animateWithDuration:timeInterval
                          
                                          animations:^{
                                              
                                              view.transform = CGAffineTransformMakeScale(zoomOut, zoomOut);  
                                              
                                          }completion:^(BOOL finish){
                                              
                                              [UIView animateWithDuration:timeInterval
                                               
                                                               animations:^{
                                                                   
                                                                   view.transform = CGAffineTransformMakeScale(1, 1);  
                                                                   
                                                               }completion:^(BOOL finish){
                                                                   
                                                                   
                                                                   
                                                               }];
                                              
                                          }];
                         
                     }];
    

}

@end





