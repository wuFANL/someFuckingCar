//
//  NSObject+QLUtil.m
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/2/2.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "NSObject+QLUtil.h"
#import <YYModel.h>
@implementation NSObject (QLUtil)
//方法替换
- (void)swizzlingInstanceMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

//model给对象相同参数赋值
- (id)modelValueFrom:(NSObject *)model {
    id result = self;
    if (self == nil) {
        result = [self.class init];
    }
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    Ivar *properties = class_copyIvarList(self.class, &count);
    for (int i = 0; i < count; i++) {
        //得到单个的成员变量
        Ivar property = properties[i];
        //得到成员变量名
        const char *propertyName = ivar_getName(property);
        NSString *propertyNameStr = [NSString stringWithUTF8String:propertyName];
        if ([propertyNameStr hasPrefix:@"_"]) {
            propertyNameStr = [propertyNameStr substringFromIndex:1];
        }
        //赋值
        id modelValue = nil;
        unsigned int modelCount;// 记录属性个数
        Ivar *modelProperties = class_copyIvarList(model.class, &modelCount);
        for (int i = 0; i< modelCount; i++) {
            //得到单个的成员变量
            Ivar modelProperty = modelProperties[i];
            //得到成员变量名
            const char *modelPropertyName = ivar_getName(modelProperty);
            NSString *modelPropertyNameStr = [NSString stringWithUTF8String:modelPropertyName];
            if ([modelPropertyNameStr hasPrefix:@"_"]) {
                modelPropertyNameStr = [modelPropertyNameStr substringFromIndex:1];
            }
            if ([propertyNameStr isEqualToString:modelPropertyNameStr]) {
                modelValue = [model valueForKey:propertyNameStr];
            }
        }
        
        if (modelValue) {
            object_setIvar(result, property,modelValue);
        }
    }
    return result;
}
@end
