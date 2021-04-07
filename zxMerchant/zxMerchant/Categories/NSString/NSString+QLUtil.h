//
//  NSString+QLUtil.h
//  luluzhuan
//
//  Created by 乔磊 on 2017/9/30.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (QLUtil)
#pragma mark -实例调用
/**
 *一次MD5
 */
- (NSString*)md5Str;
/**
 *两次MD5
 */
- (NSString *)twoMd5Str;
/**
 *自定义MD5
 */
- (NSString*) md5StrXor;
/**
 *字符串长度
 */
- (CGFloat)widthWithFont:(UIFont *)font;
- (CGFloat)widthWithFontSize:(CGFloat)fontSize;
/**
 *时间字符串转换为时间戳
 */
- (NSString *)timeStampFromString;
/**
 *时间戳转换为时间
 */
- (NSString *)timeFromString:(NSString *)dateFormat;
/**
 *时间字符串转换为时间
 */
- (NSDate *)dateFromString:(NSString *)dateFormat;
/**
 *时间戳转化为多久前
 */
- (NSString *)timeBeforeInfo;
/**
 *截取URL中的参数
 *@return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters;
/**
 *拼接URL参数 @param  param 参数
 */
- (NSString *)appendParamByDic:(NSMutableDictionary *)param;
/**
 *URL字符编码
 */
- (NSString *)encodeHTMLCharacterEntities;
/**
 *URL字符解码
 */
- (NSString *)decodeHTMLCharacterEntities;
/**
 *小数点后是否是两位
 */
- (BOOL)stringMoreTwoDecimal;
/**
 *  搜索指定范围内的指定字符串
 *  @param searchString 搜索的字符
 *  @param mask         A mask specifying search options.
 *  @param range        搜索范围.
 *  @return 搜索到的字符范围.
 */
- (NSArray <NSValue *> *)rangesOfString:(NSString *)searchString options:(NSStringCompareOptions)mask serachRange:(NSRange)range;

#pragma mark -类名调用

/**
 *字符是否为空
 */
+ (BOOL)isEmptyString:(NSString *)string;
/**
 *格式化小数点后两位
 */
+ (NSString *)formatFloat:(float)f;
/**
 *格式化字节长度
 */
+ (NSString *)fileSizeWithInterge:(NSInteger)bytes;
/**
 *格式化时间
 */
+ (NSString *)humanReadableForTimeDuration:(double)timeDuration;
/**
 *格式化距离
 */
+ (NSString*) humanReadableForDistance:(double)distance;
/**
 *判断一个字符串是否全是数字
 */
+ (BOOL)isDigitalCharacters:(NSString *)string;
/**
 *获得App名字
 */
+ (NSString *)getMyApplicationName;
/**
 *获得App版本号
 */
+ (NSString *)getMyApplicationVersion;
/**
 *手机正则
 */
+ (BOOL)phoneNumAuthentication:(NSString *)phoneNum;
/**
 *判断邮箱是否是合法地址
 */
+ (BOOL)IsValidEmail:(NSString *)email;
/**
 *身份证校验
 */
+ (BOOL)identityCardNumberVerification:(NSString *)identityString;
/**
 *判断邮箱是否是合法地址
 */
+ (BOOL)isValidUrl:(NSString *)url;
@end
