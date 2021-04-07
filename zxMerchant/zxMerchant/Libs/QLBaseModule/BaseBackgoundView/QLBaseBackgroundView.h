//
//  QLTableBackgroundView.h
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/8.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLBaseButton.h"
#import "QLBaseView.h"

@class QLBaseBackgroundView;
@protocol QLBackgroundViewDelegate <NSObject>
//按钮点击
- (void)clickPlaceholderBtn:(UIButton *)sender;
@end
@interface QLBaseBackgroundView : QLBaseView
/**
 *修改图片
 */
@property (nonatomic, strong) NSString *imageName;
/**
 *图片
 */
@property (nonatomic, strong) UIImageView *imageView;
/**
 *修改文本名
 */
@property (nonatomic, strong) NSString *placeholder;
/**
 *内容相对于中心点上下偏移
 */
@property (nonatomic, assign) CGFloat offset;
/*
 *中心按钮
 */
@property (nonatomic, strong) QLBaseButton *placeholderBtn;
/**
 *delegate
 */
@property (nonatomic, weak) id<QLBackgroundViewDelegate> delegate;
@end
