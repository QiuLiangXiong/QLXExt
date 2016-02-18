//
//  NSData+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/14.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate(QLXExt)



// 1天 10:10:10   倒计时格式 time 是 倒计时秒数
+(NSString *) countDownWithRemainsSecs:(long) time;

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *) string;

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *) string;
/**
 * Retain a formated string with a real date string
 *
 * @param dateString a real date string, which can be converted to a NSDate object
 *
 * @return a string that will be x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
+ (NSString *)timeInfoWithData:(NSDate *)date;

/**
 * Retain a formated string with a real date string
 *
 * @param dateString a real date string, which can be converted to a NSDate object
 *
 * @return a string that will be x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
+ (NSString *)timeInfoWithDateString:(NSString *)dateString;


//获取年月日如:19871127.
- (NSString *)getFormatYearMonthDay;

//该日期是该年的第几周
- (int )getWeekOfYear;
//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day;
//month个月后的日期
- (NSDate *)dateafterMonth:(int)month;
//获取日
- (NSUInteger)getDay;
//获取月
- (NSUInteger)getMonth;
//获取年
- (NSUInteger)getYear;
//获取小时
- (int )getHour ;
//获取分钟
- (int)getMinute ;

//获取秒
- (int)getSec;

- (int )getHour:(NSDate *)date ;
- (int)getMinute:(NSDate *)date ;
//在当前日期前几天
- (NSUInteger)daysAgo;
//午夜时间距今几天
- (NSUInteger)daysAgoAgainstMidnight;

- (NSString *)stringDaysAgo ;

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag ;

//返回一周的第几天(周末为第一天)
- (NSUInteger)weekday ;
//转为NSString类型的
+ (NSDate *)dateFromString:(NSString *)string ;

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format ;

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format ;

+ (NSString *)stringFromDate:(NSDate *)date ;

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed ;

+ (NSString *)stringForDisplayFromDate:(NSDate *)date ;

- (NSString *)stringWithFormat:(NSString *)format ;

- (NSString *)string ;

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle ;
//返回周日的的开始时间
- (NSDate *)beginningOfWeek ;
//返回当前天的年月日.
- (NSDate *)beginningOfDay ;
//返回该月的第一天
- (NSDate *)beginningOfMonth;
//该月的最后一天
- (NSDate *)endOfMonth;
//返回当前周的周末
- (NSDate *)endOfWeek ;

+ (NSString *)dateFormatString ;

+ (NSString *)timeFormatString ;

+ (NSString *)timestampFormatString ;

// preserving for compatibility
+ (NSString *)dbFormatString ;

- (NSUInteger) daysInMonth:(NSDate *)date;
@end
