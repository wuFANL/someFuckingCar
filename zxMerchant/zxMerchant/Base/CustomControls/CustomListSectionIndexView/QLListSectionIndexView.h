//
//  QLListSectionIndexView.h
//  
//
//  Created by 乔磊 on 2017/9/29.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QLListSectionIndexView;
@protocol QLListSectionIndexDelegate <NSObject>
- (void)indexClickEvent:(NSInteger)index;
@end
@interface QLListSectionIndexView : UIView
/**
 *初始化
 */
- (instancetype)initWithFrame:(CGRect)frame IndexArray:(NSMutableArray *)indexArr;
/**
 *字母数组
 */
@property (nonatomic, strong) NSArray *indexArr;
/**
 *关联view
 *索引点中,关联view可自行滑动
 */
@property (nonatomic, strong) UIView *relevanceView;
/**
 *搜索图片
 */
@property (nonatomic, strong) UIImage *searchImg;
/**
 *背景默认图片
 */
@property (nonatomic, strong) UIImage *defaultImg;
/**
 *背景选中图片
 */
@property (nonatomic, strong) UIImage *selectImg;
/**
 *字体默认颜色
 */
@property (nonatomic, strong) UIColor *defaultColor;
/**
 *字体选中颜色
 */
@property (nonatomic, strong) UIColor *selectColor;
/**
 *字体大小设置
 */
@property (nonatomic, strong) UIFont *font;
/**
 *当前区域
 */
@property (nonatomic, assign) NSInteger sectionIndex;
/**
 *scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;
/**
  *代理
  */
@property (nonatomic, weak) id<QLListSectionIndexDelegate> delegate;
@end

