//
//  UIButton+QLUtil.h
//  QLKit
//
//  Created by 乔磊 on 2018/5/7.
//  Copyright © 2018年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, QLButtonEdgeInsetsStyle) {
    QLButtonEdgeInsetsStyleTop,     // image在上，label在下
    QLButtonEdgeInsetsStyleLeft,    // image在左，label在右
    QLButtonEdgeInsetsStyleBottom,  // image在下，label在上
    QLButtonEdgeInsetsStyleRight    // image在右，label在左
};
@interface UIButton (QLUtil)
/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(QLButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;
@end
