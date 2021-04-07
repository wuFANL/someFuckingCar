//
//  QLBaseViewController.h
//
//
//  Created by 乔磊 on 2017/9/26.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLBaseBackgroundView.h"
@class QLBaseViewController;
@protocol QLBaseViewControllerDelegate <NSObject>
@optional
- (void)centerBtnClick:(UIButton *)sender;
- (void)resultPass:(NSDictionary *)resultDic;
@end
@interface QLBaseViewController : UIViewController
/**
 *背景页面
 */
@property (nonatomic, strong) QLBaseBackgroundView *backgroundView;
/**
 *是否显示背景
 */
@property (nonatomic, assign) BOOL showBackgroundView;
/**
 *背景标题
 */
@property (nonatomic, strong) NSString *backgroundViewTitle;
/**
 *加载中显示
 */
@property (nonatomic, assign) BOOL showLoadView;
/**
 *无数据显示
 */
@property (nonatomic, assign) BOOL showNoDataView;
/**
 *加载失败显示
 */
@property (nonatomic, assign) BOOL showLoadErrorView;
/**
 *代理
 */
@property (nonatomic, weak) id<QLBaseViewControllerDelegate> baseDelegate;
/*
 *从导航栏获取上个控制器
 *@return 上个控制器
 */
- (UIViewController *)getLastVCByNaviBar;
/**
 *  是否启用键盘管理
 *
 *  @return YES：启用，NO：不启用，默认是启用状态，如不想使用自行关闭
 */
- (BOOL)keyboardManagerEnabled;
@end
