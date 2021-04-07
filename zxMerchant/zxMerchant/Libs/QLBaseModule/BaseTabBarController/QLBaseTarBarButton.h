//
//  QLBaseTarBarButton.h
//  Template
//
//  Created by 乔磊 on 2017/5/29.
//  Copyright © 2017年 QL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLBaseTarBarButton : UIButton
@property(nonatomic, strong) UITabBarItem *tabBarItem;
/**
 *QLBaseTarBarItem的默认颜色
 */
@property (nonatomic, strong) UIColor *itemColor;
/**
 *QLBaseTarBarItem的选中颜色
 */
@property (nonatomic, strong) UIColor *itemSelectedColor;
/*
 *设置角标数量
 */
@property (nonatomic, copy) NSString *badgeValue;
/*
 *角标
 */
@property (nonatomic, strong) QLBadgeButton *badgeBtn;
@end
