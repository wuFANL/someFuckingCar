//
//  NSDate+Util.m
//  Scheming
//
//  Created by westel on 15/8/26.
//  Copyright (c) 2015年 Gengjf. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)

- (NSDateComponents *)calendar {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; //设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:self];
    return comps;
}
#pragma mark- 获取年
- (NSInteger)year {
    NSDateComponents *comps = [self calendar];
    NSInteger year = [comps year]; //获取年对应的长整形字符串
    return year;
}
#pragma mark- 获取月
- (NSInteger)month {
    NSDateComponents *comps = [self calendar];
    NSInteger month = [comps month]; //获取月对应的长整形字符串
    
    return month;
}
#pragma mark- 获取日
- (NSInteger)day {
    NSDateComponents *comps = [self calendar];
    NSInteger day = [comps day]; //获取日对应的长整形字符串
    return day;
}
#pragma mark- 获取指定天数之后日期
- (NSString *)getNDay:(NSInteger)n {
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    if(n!=0){
        //1天的长度
        NSTimeInterval  oneDay = 24*60*60*1;
        //initWithTimeIntervalSinceNow是从现在往前后推的秒数
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*n ];
    }else{
        theDate = nowDate;
    }
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    return the_date_str;
}
#pragma mark- 返回日期字符串
- (NSString *)convertToString:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:dateFormat];
    NSString *string = [formatter stringFromDate:self];
    return string;
}
#pragma mark- 对比时间差
- (NSDateComponents *)compareTimeDifference:(NSDate *)endTime {
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:self toDate:endTime options:0];
    return dateCom;
}
#pragma mark- 时间比较前后
- (int)compareTimeSize:(NSDate *)anotherDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM--dd HH:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:self];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDate];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    QLLog(@"date1 : %@, date2 : %@", self, anotherDate);
    if (result == NSOrderedDescending) {
        return 1;//时间未到 oneDay > anotherDay
    }
    else if (result == NSOrderedAscending){
        return -1;//时间已过 oneDay < anotherDay
    }
    return 0;//相等
    
}
@end
