//
//  NSDate+Util.h
//  Scheming
//
//  Created by westel on 15/8/26.
//  Copyright (c) 2015年 Gengjf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)
/**
 *获取年
 */
- (NSInteger)year;
/**
 *获取月
 */
- (NSInteger)month;
/**
 *获取日
 */
- (NSInteger)day;
/**
 *获取指定天数之后日期
 */
- (NSString *)getNDay:(NSInteger)n;
/**
 *date转换为string
 */
- (NSString *)convertToString:(NSString *)dateFormat;
/**
 *对比时间差
 */
- (NSDateComponents *)compareTimeDifference:(NSDate *)endTime;
/**
 *时间比较前后
 */
- (int)compareTimeSize:(NSDate *)anotherDate;
@end
