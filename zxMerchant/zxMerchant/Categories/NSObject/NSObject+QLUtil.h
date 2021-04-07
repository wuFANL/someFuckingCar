//
//  NSObject+QLUtil.h
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/2/2.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (QLUtil)
/**
 方法替换
 Class class = NSClassFromString(@"__NSDictionaryM");//✅
 Class class = objc_getClass("__NSDictionaryM");//✅
 Class class = object_getClass(@"__NSDictionaryM");//❌ Returns the class of an object.
Example:
 [objc_getClass("__NSDictionaryM") swizzlingMethod:@selector(setObject:forKey:) swizzledSelector:@selector(swizzled_setObject:forKey:)];
 */
- (void)swizzlingInstanceMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
/*
 *model给对象的相同属性名赋值
 *@return 返回赋值完的对象
 */
- (id)modelValueFrom:(NSObject *)model;

@end

NS_ASSUME_NONNULL_END
