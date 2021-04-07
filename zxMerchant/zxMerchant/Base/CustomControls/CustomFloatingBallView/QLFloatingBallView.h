//
//  QLFloatingBallView.h
//  BORDRIN
//
//  Created by 乔磊 on 2018/8/3.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QLFloatingBallView;
@protocol QLFloatingBallViewDelegate <NSObject>
@optional
- (void)controlClickAction:(UIControl *)sender;
@end
@interface QLFloatingBallView : UIControl
/*
 *背景图片
 */
@property (nonatomic, strong) UIImage *bjImg;
/**
 *代理
 */
@property (nonatomic, weak) id<QLFloatingBallViewDelegate> delegate;
/**
 *  显示
 */
- (void)show;
/**
 *  隐藏
 */
- (void)hidden;
/**
 *  移除
 */
- (void)remove;

@end
