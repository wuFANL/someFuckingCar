//
//  NSString+Extension.h
//  XZ_WeChat
//
//  Created by 郭现壮 on 16/9/27.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)
//表情转码
- (NSString *)emoji;
//根据内容返回尺寸
- (CGSize)sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font;

- (NSString *)originName;
//当前时间
+ (NSString *)currentName;
//字符截取-> 数组
- (NSString *)firstStringSeparatedByString:(NSString *)separeted;
+ (NSString *)currentNameForChatList;
@end
