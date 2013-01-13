//
//  TDUtility.m
//  Three20-Demo
//
//  Created by haoyu on 13-1-13.
//  Copyright (c) 2013年 haoyu. All rights reserved.
//

#import "TDUtility.h"

#define DEFAULT_DATE_TIME_ZONE_FORMAT   (@"yyyy-MM-dd HH:mm:ss Z")
#define DEFAULT_DATE_TIME_FORMAT        (@"yyyy-MM-dd HH:mm:ss")
#define DEFAULT_DATE_DATE_FORMAT        (@"yyyy-MM-dd")

@implementation TDUtility

/*
 TODO:采用正则表达式解析日期
 http://www.codingoptimist.com/2009/07/using-javascript-and-regex-to-parse.html
 http://stackoverflow.com/questions/7048828/how-can-i-parse-multiple-unknown-date-formats-in-python
*/
+ (NSDate*)convertStrToDate:(NSString*)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DEFAULT_DATE_TIME_ZONE_FORMAT];
    NSDate *date = [formatter dateFromString:dateStr];
    
    if (date == nil)
    {
        [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [formatter setDateFormat:DEFAULT_DATE_TIME_FORMAT];
        date = [formatter dateFromString:dateStr];
        
        if (date == nil)
        {
            [formatter setDateFormat:DEFAULT_DATE_DATE_FORMAT];
            date = [formatter dateFromString:dateStr];
        }
    }
    
    return date;
}

+ (NSString*)convertTimeToRelativeTime:(NSDate*)time
{
    NSInteger seconds =  0 - [time timeIntervalSinceNow];
    NSInteger minutes = seconds / 60;
    NSInteger hours = minutes / 60;
    NSInteger days = hours / 24;
    NSInteger mounths = days / 30;
    
    if (seconds >= 0)
    {
        if (mounths >= 1)
        {
            return [NSString stringWithFormat:@"%d月前", mounths];
        }
        else if (days >= 1)
        {
            return [NSString stringWithFormat:@"%d天前", days];
        }
        else if (hours >= 1)
        {
            return [NSString stringWithFormat:@"%d小时前", hours];
        }
        else if (minutes >= 1)
        {
            return [NSString stringWithFormat:@"%d分钟前", minutes];
        }
        else
        {
            return @"刚刚";
        }
    }
    else
    {
        if (mounths <= -1)
        {
            return [NSString stringWithFormat:@"%d月后", -mounths];
        }
        else if (days <= -1)
        {
            return [NSString stringWithFormat:@"%d天后", -days];
        }
        else if (hours<= -1)
        {
            return [NSString stringWithFormat:@"%d小时后", -hours];
        }
        else if (minutes <= -1)
        {
            return [NSString stringWithFormat:@"%d分钟后", -minutes];
        }
        else
        {
            return @"马上";
        }
    }
}

@end
