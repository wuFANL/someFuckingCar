//
//  QLBaseTabBarController.h
//  Template
//
//  Created by jgs on 2017/5/27.
//  Copyright © 2017年 QL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLBadgeButton.h"
#import "QLBaseTarBarButton.h"
#import "QLBaseTabBar.h"


@interface QLBaseTabBarController : UITabBarController
/**
 *mainTabBar
 */
@property (nonatomic, strong) QLBaseTabBar *mainTabBar;
/**
 *QLBaseTarBarItem的默认颜色
 */
@property (nonatomic, strong) UIColor *itemColor;
/**
 *QLBaseTarBarItem的选中颜色
 */
@property (nonatomic, strong) UIColor *itemSelectedColor;
/**
 *是否在TabBar中间添加按钮
 */
@property (nonatomic, assign) BOOL showCenterBtn;
/**
 *TabBar中间添加按钮图片
 */
@property (nonatomic, strong) NSString *centerBtnImageNmae;
/**
 *子页面设置
 */
- (void)setChildControllers:(NSArray <UIViewController *> *)childs titles:(NSArray <NSString *> *)titles defaultImages:(NSArray <NSString *> *)imageNames selectedImages:(NSArray <NSString *> *)selectedImageNames;
@end
