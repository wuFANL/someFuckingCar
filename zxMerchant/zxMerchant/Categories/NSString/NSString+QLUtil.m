//
//  NSString+QLUtil.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/9/30.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "NSString+QLUtil.h"
#import <CommonCrypto/CommonDigest.h>
#define WCLUtilityZeroEnd @".0"
@implementation NSString (QLUtil)
#pragma mark---------------1、实例调用
#pragma mark- /**一次MD5*/
- (NSString*) md5Str{
    const  char * myPassword = [self UTF8String];
    unsigned char md5c[16];
    CC_MD5(myPassword, (CC_LONG)strlen(myPassword), md5c);
    NSMutableString *md5Str = [NSMutableString string];
    for(int i = 0; i < 16; i++){
        [md5Str appendFormat:@"%02x",md5c[i]];
    }
    return [md5Str copy];
}
#pragma mark- /**两次MD5*/
- (NSString *)twoMd5Str {
    
    NSString *md5Str = [self md5Str];
    NSString *twoMd5Str = [md5Str md5Str];
    return [twoMd5Str copy];
}
#pragma mark- /**自定义MD5*/
- (NSString *)md5StrXor{
    const  char * myPassword = [self UTF8String];
    unsigned char md5c[16];
    CC_MD5(myPassword, (CC_LONG)strlen(myPassword), md5c);
    NSMutableString *md5Str = [NSMutableString string];
    [md5Str appendFormat:@"%02x",md5c[0]];
    for(int i = 1; i < 16; i++){
        [md5Str appendFormat:@"%02x",
         md5c[i]^md5c[0]];
    }
    return [md5Str copy];
}
#pragma mark- /**字符串宽度*/
- (CGFloat)widthWithFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    size = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    
    return ceilf(size.width);
}
- (CGFloat)widthWithFontSize:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeZero;
    size = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    
    return ceilf(size.width);
}
#pragma mark- /**字符串行数*/
-(NSInteger)rowsOfStringWithFont:(UIFont *)font withWidth:(CGFloat)width {
    if (!self || self.length == 0) {
        return 0;
    }
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,width,MAXFLOAT));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    return lines.count;
}
#pragma mark- /**时间字符串转换为时间戳*/
- (NSString *)timeStampFromString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_CN"]];
    NSDate* dateTodo = [formatter dateFromString:self];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateTodo timeIntervalSince1970]];
    return timeSp;
}
#pragma mark- /**时间戳转换为时间*/
- (NSString *)timeFromString:(NSString *)dateFormat {
    NSTimeInterval temTime = self.integerValue;
    if (self.length > 10) {
        temTime = self.integerValue/1000;
    }
    NSDate *dateTodo = [NSDate dateWithTimeIntervalSince1970:temTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *timeSp = [NSString stringWithFormat:@"%@",[formatter stringFromDate:dateTodo]];
    return timeSp;
}
#pragma mark- /**时间字符串转换为时间*/
- (NSDate *)dateFromString:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate* dateTodo = [formatter dateFromString:self];
    return dateTodo;
}
#pragma mark- 时间戳转化为多久前
- (NSString *)timeBeforeInfo {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_CN"]];
    
    NSTimeInterval timeIntrval = self.length==13?[self integerValue]/1000.0:[self integerValue];
    //获取此时时间戳长度
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowTimeinterval - timeIntrval; //时间差
    int year = timeInt / (3600 * 24 * 30 *12);
    int day = timeInt / (3600 * 24);
    int minute = timeInt / 60;
    if(minute>0&&minute<=1) {
        return [NSString stringWithFormat:@"刚刚"];
    } else if (minute>1&&day <= 1) {
        NSDate *detaildate= [NSDate dateWithTimeIntervalSince1970:timeIntrval];
        return [detaildate convertToString:@"HH:mm"];
    } else if (day > 1&&year <= 1) {
        NSDate *detaildate= [NSDate dateWithTimeIntervalSince1970:timeIntrval];
        return [detaildate convertToString:@"MM-dd HH:mm"];
    } else {
        NSDate *detaildate= [NSDate dateWithTimeIntervalSince1970:timeIntrval];
        return [detaildate convertToString:@"YYYY-MM-dd HH:mm"];
    }
}
#pragma mark- /**截取URL中的参数*/
- (NSMutableDictionary *)getURLParameters {
    // 查找参数
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 截取参数
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                } else {
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        // 设置值
        [params setValue:value forKey:key];
    }
    return params;
}
#pragma mark- /**拼接URL中的参数*/
- (NSString *)appendParamByDic:(NSMutableDictionary *)param {
    if (param == nil) {
        param = [NSMutableDictionary dictionary];
    }
    
    NSString *url = self;
    url = [url stringByRemovingPercentEncoding];
    if ([self containsString:@"?"]) {
        NSArray *urlArr = [self componentsSeparatedByString:@"?"];
        if (urlArr.count >= 2) {
            //有参数
            if(![url hasSuffix:@"&"]) {
                url = [self stringByAppendingString:@"&"];
            }
        } else {
            //无参数
            QLLog(@"无参链接");
        }
        
    }else {
        url = [self stringByAppendingString:@"?"];
    }
    
    for (NSString *key in param) {
        NSString *value = param[key];
        if(key!=nil&&value!=nil&&key.length>0) {
            if (![url containsString:key]) {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,value]];
            }
        }
    }
    
    if([url hasSuffix:@"&"]){
        url = [url substringToIndex:url.length-1];
    }
    //转化为UTF-8编码格式
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return url;
}

#pragma mark- /**URL字符编码*/
- (NSString *)encodeHTMLCharacterEntities {
    NSMutableString *encoded = [NSMutableString stringWithString:self];
    
    // @"&amp;"
    NSRange range = [self rangeOfString:@"&"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"&"
                                 withString:@"&amp;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&lt;"
    range = [self rangeOfString:@"<"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"<"
                                 withString:@"&lt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&gt;"
    range = [self rangeOfString:@">"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@">"
                                 withString:@"&gt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    return encoded;
}
#pragma mark- /**URL字符解码*/
- (NSString *)decodeHTMLCharacterEntities {
    if ([self rangeOfString:@"&"].location == NSNotFound) {
        return self;
    } else {
        NSMutableString *escaped = [NSMutableString stringWithString:self];
        NSArray *codes = [NSArray arrayWithObjects:
                          @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
                          @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
                          @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
                          @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
                          @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
                          @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
                          @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
                          @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
                          @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
                          @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
                          @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
                          @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
                          @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
                          @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;", nil];
        
        NSUInteger i, count = [codes count];
        
        // Html
        for (i = 0; i < count; i++) {
            NSRange range = [self rangeOfString:[codes objectAtIndex:i]];
            if (range.location != NSNotFound) {
                [escaped replaceOccurrencesOfString:[codes objectAtIndex:i]
                                         withString:[NSString stringWithFormat:@"%C", (unsigned short) (160 + i)]
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [escaped length])];
            }
        }
    
        // @"&amp;"
        NSRange range = [self rangeOfString:@"&amp;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&amp;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 38]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&lt;"
        range = [self rangeOfString:@"&lt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&lt;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 60]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&gt;"
        range = [self rangeOfString:@"&gt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&gt;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 62]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&apos;"
        range = [self rangeOfString:@"&apos;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&apos;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 39]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&quot;"
        range = [self rangeOfString:@"&quot;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&quot;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 34]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // Decimal & Hex
        NSRange start, finish, searchRange = NSMakeRange(0, [escaped length]);
        i = 0;
        
        while (i < [escaped length]) {
            start = [escaped rangeOfString:@"&#"
                                   options:NSCaseInsensitiveSearch
                                     range:searchRange];
            
            finish = [escaped rangeOfString:@";"
                                    options:NSCaseInsensitiveSearch
                                      range:searchRange];
            
            if (start.location != NSNotFound && finish.location != NSNotFound &&
                finish.location > start.location) {
                NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
                NSString *entity = [escaped substringWithRange:entityRange];
                NSString *value = [entity substringWithRange:NSMakeRange(2, [entity length] - 2)];
                
                [escaped deleteCharactersInRange:entityRange];
                
                if ([value hasPrefix:@"x"]) {
                    unsigned tempInt = 0;
                    NSScanner *scanner = [NSScanner scannerWithString:[value substringFromIndex:1]];
                    [scanner scanHexInt:&tempInt];
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unsigned short) tempInt] atIndex:entityRange.location];
                } else {
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unsigned short) [value intValue]] atIndex:entityRange.location];
                } i = start.location;
            } else { i++; }
            searchRange = NSMakeRange(i, [escaped length] - i);
        }
        
        return escaped;    // Note this is autoreleased
    }
}
#pragma mark- /**小数点后是否是两位*/
- (BOOL)stringMoreTwoDecimal {
    if ([self containsString:@"."]) {
        NSArray *confineArr = [self componentsSeparatedByString:@"."];
        if (confineArr.count == 2) {
            NSString *decimalStr = confineArr[1];
            if (decimalStr.length > 2) {
                return YES;
            }
        }
        if (confineArr.count > 2) {
            QLLog(@"大于一个小数点");
        }
    }
    return NO;
}
#pragma mark- /**搜索指定范围内的指定字符串*/
- (NSArray <NSValue *> *)rangesOfString:(NSString *)searchString options:(NSStringCompareOptions)mask serachRange:(NSRange)range {
    
    NSMutableArray *array = [NSMutableArray array];
    [self rangeOfString:searchString range:NSMakeRange(0, self.length) array:array options:mask];
    
    return array;
}
- (void)rangeOfString:(NSString *)searchString
                range:(NSRange)searchRange
                array:(NSMutableArray *)array
              options:(NSStringCompareOptions)mask {
    
    NSRange range = [self rangeOfString:searchString options:mask range:searchRange];
    
    if (range.location != NSNotFound) {
        [array addObject:[NSValue valueWithRange:range]];
        [self rangeOfString:searchString
                      range:NSMakeRange(range.location + range.length, self.length - (range.location + range.length))
                      array:array
                    options:mask];
    }
}
#pragma mark---------------2、类名调用
#pragma mark- /**字符是否为空*/
+ (BOOL)isEmptyString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        
        return YES;
    }
    
    return NO;
}
#pragma mark- /**格式化小数点后两位*/
+ (NSString *)formatFloat:(float)f {
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}
#pragma mark- /**格式化字节长度*/
+ (NSString *)fileSizeWithInterge:(NSInteger)bytes {
    // 1k = 1024, 1m = 1024k
    if (bytes < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)bytes];
    }else if (bytes < 1024 * 1024){// 小于1m
        CGFloat aFloat = bytes/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (bytes < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = bytes/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = bytes/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}
#pragma mark- /**格式化距离*/
+ (NSString*)humanReadableForDistance:(double)distance {
    NSString *humanReadable = nil;
    NSInteger theLength = (NSInteger)distance;
    // 米.
    if (theLength < 1000) {
        humanReadable = [NSString stringWithFormat:@"%ld米", (long)theLength];
    }
    // 公里.
    else {
        humanReadable = [NSString stringWithFormat:@"%.1f", theLength / 1000.0];
        
        BOOL zeroEnd = [humanReadable hasSuffix:WCLUtilityZeroEnd];
        
        // .0结尾, 去掉尾数.
        if (zeroEnd) {
            humanReadable = [humanReadable substringWithRange:NSMakeRange(0, humanReadable.length - WCLUtilityZeroEnd.length)];
        }
        
        humanReadable = [humanReadable stringByAppendingString:@"公里"];
    }
    
    return humanReadable;
}
#pragma mark- /**格式化时间*/
+ (NSString *)humanReadableForTimeDuration:(double)timeDuration {
    NSString *humanReadable = nil;
    NSInteger theDuration = (NSInteger)timeDuration;
    // 分.
    if (theDuration < 60) {
        humanReadable = [NSString stringWithFormat:@"%ld分", (long)theDuration];
    } else {
        //时.
        humanReadable = [NSString stringWithFormat:@"%ld时", (long)theDuration / 60];
        double remainder = fmod(theDuration, 60.0);
        if (remainder != 0) {
            NSString *remainderHumanReadable = [self humanReadableForTimeDuration:remainder];
            
            humanReadable = [humanReadable stringByAppendingString:remainderHumanReadable];
        }
    }
    return humanReadable;
}
#pragma mark- /**判断一个字符串是否全是数字*/
+ (BOOL)isDigitalCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}
#pragma mark- /**App版本号*/
+ (NSString *)getMyApplicationVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleVersion"];
    return version;
}
#pragma mark- /**App名字*/
+ (NSString *)getMyApplicationName {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [info objectForKey:@"CFBundleDisplayName"];
    return name;
}
#pragma mark- /**手机正则*/
+ (BOOL)phoneNumAuthentication:(NSString *)phoneNum {
    NSString *regexStr = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) return NO;
    NSInteger count = [regular numberOfMatchesInString:phoneNum options:NSMatchingReportCompletion range:NSMakeRange(0, phoneNum.length)];
    if (count > 0) {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark- /**判断邮箱是否是合法地址*/
+ (BOOL)IsValidEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma mark- /**判断邮箱是否是合法地址*/
+ (BOOL)isValidUrl:(NSString *)url {
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:url];
}
#pragma mark- /**身份证校验*/
+ (BOOL)identityCardNumberVerification:(NSString *)identityString {
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    //** 开始进行校验 *//
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex  = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum      += subStrIndex * idCardWiIndex;
    }
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}
@end
