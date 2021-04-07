//
//  UIColor+JGColorChange.h
//  Store
//
//  Created by jgs on 16/12/26.
//  Copyright © 2016年 JGS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QLUtil)
// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *)colorWithHexString: (NSString *)color;
@end
