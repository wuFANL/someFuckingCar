//
//  QLBaseLabel.h
//  test
//
//  Created by 乔磊 on 2019/4/6.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol QLAttributeTapActionDelegate <NSObject>
@optional
/**
 *  QLAttributeTapActionDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 */
- (void)tapAttributeInLabel:(UILabel *)label string:(NSString *)string range:(NSRange)range;
@end
@interface QLBaseLabel : UILabel
/**
 *是否自适应大小
 */
@property (nonatomic, assign) IBInspectable BOOL autoFit;
/*
 *滑动效果
 */
@property (nonatomic, assign) IBInspectable BOOL isScroll;
/**
 *动画时间
 */
@property (nonatomic, assign) IBInspectable CGFloat animateDuration;
/*
 *是否可以点击
 */
@property (nonatomic, assign) IBInspectable BOOL isTapAction;
/**
 *代理
 */
@property (nonatomic, weak) id<QLAttributeTapActionDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
