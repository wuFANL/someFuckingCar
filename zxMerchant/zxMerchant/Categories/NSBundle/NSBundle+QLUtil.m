//
//  NSBundle+QLUtil.m
//  WisdomCB
//
//  Created by 乔磊 on 2019/3/1.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "NSBundle+QLUtil.h"

static NSString *const QLUserLanguageKey = @"QLUserLanguageKey";

@implementation NSBundle (QLUtil)
+ (BOOL)isChineseLanguage {
    NSString *currentLanguage = [self currentLanguage];
    if ([currentLanguage hasPrefix:@"zh-Hans"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)currentLanguage {
    return [QLLanguageConfig userLanguage]? :[NSLocale preferredLanguages].firstObject;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //动态继承、交换，方法类似KVO，通过修改[NSBundle mainBundle]对象的isa指针，使其指向它的子类QLBundle，这样便可以调用子类的方法；其实这里也可以使用method_swizzling来交换mainBundle的实现，来动态判断，可以同样实现。
        object_setClass([NSBundle mainBundle], [QLBundle class]);
    });
}
@end

@implementation QLBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    if ([QLBundle ql_mainBundle]) {
        return [[QLBundle ql_mainBundle] localizedStringForKey:key value:value table:tableName];
    } else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

+ (NSBundle *)ql_mainBundle {
    if ([NSBundle currentLanguage].length) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSBundle currentLanguage] ofType:@"lproj"];
        if (path.length) {
            
            return [NSBundle bundleWithPath:path];
        }
    }
    return nil;
}

@end

@implementation QLLanguageConfig
/*
 *设置当前语言
 */
+ (void)setUserLanguage:(NSString *)userLanguage {
    //跟随手机系统
    if (!userLanguage.length) {
        [self resetSystemLanguage];
        return;
    }
    //用户自定义
    [UserDefaults setValue:userLanguage forKey:QLUserLanguageKey];
    [UserDefaults setValue:@[userLanguage] forKey:@"AppleLanguages"];
    [UserDefaults synchronize];
}
/*
 *当前语言
 */
+ (NSString *)userLanguage {
    return [UserDefaults valueForKey:QLUserLanguageKey];
}

/**
 重置系统语言
 */
+ (void)resetSystemLanguage {
    [UserDefaults removeObjectForKey:QLUserLanguageKey];
    [UserDefaults setValue:nil forKey:@"AppleLanguages"];
    [UserDefaults synchronize];
}

@end
