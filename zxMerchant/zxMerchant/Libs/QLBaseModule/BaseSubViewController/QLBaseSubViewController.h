//
//  QLBaseSubViewController.h
//  JSTY
//
//  Created by 乔磊 on 2018/5/8.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLBaseViewController.h"

@class QLBaseSubViewController;
@protocol QLBaseSubViewControllerDelegate<NSObject>
@optional
/**
 *页面切换回调
 */
- (void)subViewChange:(UIViewController *)currentVC IndexPath:(NSInteger)index;

@end
@interface QLBaseSubViewController : QLBaseViewController
/**
 *是否增加左右手势
 */
@property (nonatomic, assign) BOOL needGestureRecognizer;
/**
 *子页面数组（必须）
 */
@property (nonatomic, strong) NSArray<UIViewController *> *subVCArr;
/**
 *代理
 */
@property (nonatomic, weak) id<QLBaseSubViewControllerDelegate> delegate;
/**
 *转场动画
 */
- (void)viewChangeAnimation:(NSInteger)index;
@end
