//
//  NSDate+Additions.h
//  Classes
//
//  Created by JHorn.Han on 10/19/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSDate (DatePrinters)

// 14点
- (NSString *)shortTimeString;

// eg.2012年5月12
- (NSString *)dateString;

// eg 星期二
- (NSString *)weekdayString;

// eg 周二
- (NSString *)shortWeekdayString;

//eg.2012年12月2日 下午4点或16点
-(NSString *)dateTimeStringYYMMMddHm;
//eg.eg. 12年12月2日 下午4点或16点
-(NSString *)dateTimeStringYYYY_MM_DDHm;
//eg 2012-12-02 13:32:32
-(NSString *)dateTimeStringYYYY_MM_DD_HH_MM_SS;


- (NSString *)longDateTimeString;

@end


@interface NSDate (DateHelpers)
- (NSDate *)nextHour;
- (NSDate *)prevHour;
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;
- (NSDate *)prevDay;
- (NSDate *)nextDay;
- (NSDate *)prevWeek;
- (NSDate *)nextWeek;

- (NSDate *)justTime;

- (NSDate *)justHour;


+ (NSDate *)nowTime;

- (NSDate *)beginOfDay;

- (NSDate *)endOfDay;

- (NSDate *)middleOfDay;

//四舍五入到分钟 minutes == 0 忽略分钟
- (NSDate *)dateRoundedToMinutes:(NSUInteger)minutes;

+ (NSDate *)dateWithHour:(NSUInteger)hour minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds;

- (NSInteger)daysSinceDate:(NSDate *)date;

- (BOOL)isWeekend;

- (BOOL)isEarlier:(NSDate *)other;
- (BOOL)isLater:(NSDate *)other;
@end


@interface NSDate (Decomposition)

@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger year;

@end

