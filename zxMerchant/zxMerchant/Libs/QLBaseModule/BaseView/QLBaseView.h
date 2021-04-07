//
//  QLBaseView.h
//  Integral
//
//  Created by 乔磊 on 2019/4/3.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QLBaseView;
@protocol QLBaseViewDelegate <NSObject>
@optional
/*
 *隐藏页面事件（默认直接删除页面）
 */
- (void)hiddenViewEvent;
@end

@interface QLBaseView : UIView
/**
 *点击事件是否可以传递到下层
 */
@property (nonatomic, assign) IBInspectable BOOL canClickLower;
/**
 *代理
 */
@property (nonatomic, weak) id<QLBaseViewDelegate> viewDelegate;
/*
 *删除子页面
 */
- (void)removeSubviews;

@end

NS_ASSUME_NONNULL_END
