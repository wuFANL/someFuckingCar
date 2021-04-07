//
//  NSBundle+QLUtil.h
//  WisdomCB
//
//  Created by 乔磊 on 2019/3/1.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QLLanguageConfig;
@class QLBundle;

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (QLUtil)
/*
 *是否中文
 */
+ (BOOL)isChineseLanguage;
/*
 *当前语言
 */
+ (NSString *)currentLanguage;
@end

@interface QLBundle : NSBundle

@end

@interface QLLanguageConfig : NSObject
/**
 用户自定义使用的语言，当传nil时，等同于resetSystemLanguage
 */
@property (class, nonatomic, strong, nullable) NSString *userLanguage;
/**
 重置系统语言
 */
+ (void)resetSystemLanguage;

@end

NS_ASSUME_NONNULL_END
