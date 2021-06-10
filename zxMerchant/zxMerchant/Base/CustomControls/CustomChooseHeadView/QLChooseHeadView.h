//
//  QLChooseHeadView.h
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/3/19.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QLChooseHeadView;
@protocol QLChooseHeadViewDelegate <NSObject>
@optional
/**
 *标题设置
 */
- (void)chooseTitleStyle:(UIButton *)chooseBtn Index:(NSInteger)index;
/**
 *选择的下标
 */
- (void)chooseSelect:(UIButton * __nullable)lastBtn CurrentBtn:(UIButton * __nullable)currentBtn Index:(NSInteger)index;

@end
@interface QLChooseHeadView : UIView
/**
 *显示列数
 */
@property (nonatomic, assign) NSInteger column;
/**
 *分类数组
 */
@property (nonatomic, strong) NSArray *typeArr;
/**
 *按钮数组
 */
@property (nonatomic, strong) NSMutableArray *btnArr;
/**
 *设置选中
 */
@property (nonatomic, assign) NSInteger selectedIndex;
/**
 *选中颜色
 */
@property (nonatomic, strong) UIColor *selectColor;
/**
 *右遮罩
 */
@property (nonatomic, weak) UIView *maskView;
/**
 *是否显示下划线
 */
@property (nonatomic, assign) BOOL showLineView;
/**
 *选中下划线颜色
 */
@property (nonatomic, strong) UIColor *lineColor;
/**
 *下划线长度
 */
@property (nonatomic, assign) CGFloat lineWidth;
/**
 *是否显示右遮挡
 */
@property (nonatomic, assign) BOOL showRightMask;
/**
 *是否显示底部阴影
 */
@property (nonatomic, assign) BOOL showBottomShadow;
/**
 *代理
 */
@property (nonatomic, weak) id<QLChooseHeadViewDelegate> typeDelegate;
@end

NS_ASSUME_NONNULL_END
