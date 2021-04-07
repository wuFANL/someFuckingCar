//
//  QLBaseTabBar.h
//  Template
//
//  Created by 乔磊 on 2017/5/29.
//  Copyright © 2017年 QL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLBaseTarBarButton.h"
@class QLBaseTabBar;
@protocol QLBaseTabBarDelegate <NSObject>

@optional
- (void)tabBar:(QLBaseTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag;
- (void)tabBarClickCenterButton:(QLBaseTabBar *)tabBar;
@end

@interface QLBaseTabBar : UIView
/**
 *是否显示角标数字
 */
@property (nonatomic, assign) BOOL showBadgeText;
/*
 *按钮数组
 */
@property(nonatomic, strong) NSMutableArray *tabbarBtnArray;
/**
 *是否在中间添加按钮
 */
@property (nonatomic, assign) BOOL showCenterBtn;
/**
 *TabBar中间添加按钮图片
 */
@property (nonatomic, strong) NSString *centerBtnImageNmae;
/**
 *QLBaseTarBarItem的默认颜色
 */
@property (nonatomic, strong) UIColor *itemColor;
/**
 *QLBaseTarBarItem的选中颜色
 */
@property (nonatomic, strong) UIColor *itemSelectedColor;
/*
 *增加Item
 */
- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem;
/*
 *点击事件
 */
- (void)ClickTabBarButton:(QLBaseTarBarButton *)tabBarBtn;
/*
 *点击按钮变化
 */
- (void)btnChange:(QLBaseTarBarButton *)tabBarBtn;
/*
 *代理
 */
@property(nonatomic, weak)id <QLBaseTabBarDelegate>tbDelegate;

@end
