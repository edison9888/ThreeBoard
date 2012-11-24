//
//  NSDate+Additions.m
//  Classes
//
//  Created by JHorn.Han on 10/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "NSDate+Additions.h"


NSDateFormatter *timeFormatter = nil;
NSDateFormatter *dateFormatter = nil;
NSDateFormatter *dateTimeFormatter = nil;
NSDateFormatter *dateTimeFormatterLong = nil;

NSCalendar *curCalendar() {
     NSCalendar *calendar = nil;
    if(calendar == nil) calendar = [NSCalendar currentCalendar];
    return calendar;
}

BOOL is24HourFormat() {
    static BOOL determined = NO;
    static BOOL is24Hour = NO;
    if(! determined) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
        NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
        is24Hour = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
        determined = YES;
    }
    return is24Hour;
}

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSTimeZoneCalendarUnit)

@implementation NSDate (DatePrinters)

- (NSString *)shortTimeString {
    return [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *)dateString {
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyyMMMd" options:0 locale:[NSLocale currentLocale]]];
    }
    return [dateFormatter stringFromDate:self];
}

- (NSString *)weekdayString {
    static NSDateFormatter *wDayFormatter = nil;
    if(wDayFormatter == nil) wDayFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    NSAssert(wDayFormatter != nil, @"Date Formatter for weekdays is nil, but should have a value.");
    return [[wDayFormatter standaloneWeekdaySymbols] objectAtIndex:(MAX(0, [components weekday] - 1))]; // MAX for (very) rare cases where [components weekday] is 0. probably an Apple bug.
}

- (NSString *)shortWeekdayString {
    static NSDateFormatter *wDayFormatter = nil;
    if(wDayFormatter == nil) wDayFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    NSAssert(wDayFormatter != nil, @"Date Formatter for short weekdays is nil, but should have a value.");
    return [[wDayFormatter shortStandaloneWeekdaySymbols] objectAtIndex:([components weekday] - 1)];
}

- (NSString *)dateTimeStringYYMMMddHm {
	if(dateTimeFormatter == nil) {
		dateTimeFormatter = [[NSDateFormatter alloc] init];
        if(is24HourFormat())
            [dateTimeFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyMMMddHm" options:0 locale:[NSLocale currentLocale]]];
        else
            [dateTimeFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyMMMddhma" options:0 locale:[NSLocale currentLocale]]];
	}
	
	NSString *r = [dateTimeFormatter stringFromDate:self];
	return r;
}


- (NSString *)dateTimeStringYYYY_MM_DDHm {
	if(dateTimeFormatter == nil) {
		dateTimeFormatter = [[NSDateFormatter alloc] init];
        if(is24HourFormat())
            [dateTimeFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyyMMMddHm" options:0 locale:[NSLocale currentLocale]]];
        else
            [dateTimeFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyyMMMddhma" options:0 locale:[NSLocale currentLocale]]];
	}
	
	NSString *r = [dateTimeFormatter stringFromDate:self];
	return r;
}


//format eg. 2012-09-01 12:43:20
-(NSString*)dateTimeStringYYYY_MM_DD_HH_MM_SS
{
 //   NSTimeInterval times = [self timeIntervalSince1970];
    NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    //[outputFormatter setDateFormat:@"yyyyMMdd HHmmSS"];
    [outputFormatter setLocale:[NSLocale currentLocale]];

    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*  stroutPutEnd = [outputFormatter stringFromDate:self];
    return stroutPutEnd;
}


//-(NSString *)dateTimeStringYYYY_MM_DD_HH_MM_SS {
//
//
//}

- (NSString *)longDateTimeString {
	if(dateTimeFormatterLong == nil) {
        dateTimeFormatterLong = [[NSDateFormatter alloc] init];
        if(is24HourFormat())
            [dateTimeFormatterLong setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEyyyyMdHm" options:0 locale:[NSLocale currentLocale]]];
        else
            [dateTimeFormatterLong setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEyyyyMdhm" options:0 locale:[NSLocale currentLocale]]];
	}
	
	NSString *r = [dateTimeFormatterLong stringFromDate:self];
	return r;
}

@end


@implementation NSDate (DateHelpers)

- (NSDate *)nextHour {
	return [self dateByAddingMinutes:60];
}

- (NSDate *)prevHour {
	return [self dateByAddingMinutes:(-60)];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSDateComponents *dC = [[NSDateComponents alloc] init];
    dC.day = days;
    NSDate *res = [curCalendar() dateByAddingComponents:dC toDate:self options:0];
    return res;
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes {
	NSInteger secsToAdd = 60 * minutes;
	return [[NSDate alloc] initWithTimeInterval:secsToAdd sinceDate:self];
}

- (NSDate *)prevDay {
	return [self dateByAddingDays:(-1)];
}

- (NSDate *)nextDay {
	return [self dateByAddingDays:1];
}

- (NSDate *)prevWeek {
	return [self dateByAddingDays:((-1) * 7)];
}

- (NSDate *)nextWeek {
	return [self dateByAddingDays:(7)];
}

- (NSDate *)justTime {
	NSCalendar *calendar = curCalendar();
	static unsigned unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:self];
	[components setYear:1970]; [components setMonth:1]; [components setDay:1]; 
	return [calendar dateFromComponents:components];
}

- (NSDate *)justHour {
	NSCalendar *calendar = curCalendar();
	static unsigned unitFlags = NSHourCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:self];
	[components setYear:1970]; [components setMonth:1]; [components setDay:1];
	[components setMinute:0]; [components setSecond:0];
	return [calendar dateFromComponents:components];
}

+ (NSDate *)nowTime {
	return [[NSDate date] justTime];
}

- (NSDate *)beginOfDay {
    NSDateComponents *components = [curCalendar() components:DATE_COMPONENTS fromDate:self];
    [components setHour:0]; [components setMinute:0]; [components setSecond:0];
	return [curCalendar() dateFromComponents:components];
}

- (NSDate *)endOfDay {
    NSDateComponents *components = [curCalendar() components:DATE_COMPONENTS fromDate:self];
    [components setHour:23]; [components setMinute:59]; [components setSecond:59];
	return [curCalendar() dateFromComponents:components];
}

- (NSDate *)middleOfDay {
    NSDateComponents *components = [curCalendar() components:DATE_COMPONENTS fromDate:self];
    [components setHour:12]; [components setMinute:0]; [components setSecond:0];
	return [curCalendar() dateFromComponents:components];
}

- (NSDate *)dateRoundedToMinutes:(NSUInteger)minutes {
	NSCalendar *calendar = curCalendar();
	static unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
	NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
	NSInteger dateMinutes = [comps minute];
	if(minutes == 0) dateMinutes = 0;
	else dateMinutes = (dateMinutes / minutes) * minutes;
	[comps setMinute:dateMinutes];
	return [calendar dateFromComponents:comps];
}

+ (NSDate *)dateWithHour:(NSUInteger)hour minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds {
    NSDateComponents *components = [curCalendar() components:DATE_COMPONENTS fromDate:[NSDate date]];
    [components setHour:hour];
    [components setMinute:minutes];
    [components setSecond:seconds];
    return [curCalendar() dateFromComponents:components];
}

- (NSInteger)daysSinceDate:(NSDate *)date {
    // Note: if regressions with this method appear: both date and self had, before, a beginOfDay attached.
    
    // TODO: unit test: result for [[curCalendar() components:NSDayCalendarUnit fromDate:[date beginOfDay] toDate:[self beginOfDay] options:0] day]; should always be equal for a wide range of dates
    
    // NOTE: known edge cases: late on the day (e.g self = 2010-10-24 23:00:00 +0000, date = 2012-01-07 22:02:19 +0000)
    
    // to handle differences between summer and winter time, maybe remove 1.5 hours.
    // not sure if correct in all cases.
//    NSInteger result = ceil([[self beginOfDay] timeIntervalSinceDate:date] / (60 * 60 * 24.0));
//#ifndef NDEBUG
//    NSInteger testResult = [[curCalendar() components:NSDayCalendarUnit fromDate:[date beginOfDay] toDate:[self beginOfDay] options:0] day];
//    NSAssert2(result == testResult, @"Fast daysSinceDate result differes from slow variant: %d instead of %d", result, testResult);
//#endif
    
    NSInteger result = [curCalendar() components:NSDayCalendarUnit fromDate:date toDate:self options:0].day;
    return result;
}

- (NSInteger)daysSinceDateFast:(NSDate *)date {
    return ceil([self timeIntervalSinceDate:date] / (60 * 60 * 24.0));
}

- (BOOL)isWeekend {
    NSCalendar *cal = curCalendar();
    NSRange weekdayRange = [cal maximumRangeOfUnit:NSWeekdayCalendarUnit];
    NSDateComponents *components = [cal components:NSWeekdayCalendarUnit fromDate:self];
    NSUInteger weekdayOfDate = [components weekday];
    
    return weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length;
}

- (BOOL)isEarlier:(NSDate *)other {
    return [self earlierDate:other] == self;
}
- (BOOL)isLater:(NSDate *)other {
    return [self laterDate:other] == self;
}

@end


@implementation NSDate (Decomposition)

- (NSInteger)hour {
    NSDateComponents *components = [curCalendar() components:DATE_COMPONENTS fromDate:self];
	return [components hour];
}

- (NSInteger)minute {
    NSDateComponents *components = [curCalendar() components:DATE_COMPONENTS fromDate:self];
	return [components minute];
}

- (NSInteger)day {
    NSDateComponents *components = [curCalendar() components:DATE_COMPONENTS fromDate:self];
	return [components day];
}

- (NSInteger)month {
    NSDateComponents *components = [curCalendar() components:DATE_COMPONENTS fromDate:self];
	return [components month];
}

- (NSInteger)year {
    NSDateComponents *components = [curCalendar() components:DATE_COMPONENTS fromDate:self];
	return [components year];
}

@end
