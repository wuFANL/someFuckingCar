//
//  QLRoundSearchBar.h
//  luluzhuan
//
//  Created by 乔磊 on 2017/9/27.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QLBaseSearchBar;
@protocol QLBaseSearchBarDelegate <NSObject>
@optional
/**
 *不能编辑，点击回调
 */
- (void)noEditClick;
@end
@interface QLBaseSearchBar : UISearchBar
/**
 *placeholder是否居中显示
 */
@property (nonatomic, assign, setter = setHasCentredPlaceholder:) BOOL hasCentredPlaceholder;
/**
 *是否圆角
 */
@property (nonatomic, assign) IBInspectable BOOL isRound;
/**
 *是否不可编辑，能点击
 */
@property (nonatomic, assign) IBInspectable BOOL noEditClick;
/**
 *textField
 */
@property (nonatomic, strong) UITextField *textField;
/**
 *textField背景色
 */
@property (nonatomic, strong) IBInspectable UIColor *bjColor;
/**
 *textField占位符默认位置
 */
@property (nonatomic, assign) IBInspectable UIOffset defaultOffset;
/**
 *textField占位符字体
 */
@property (nonatomic, strong) IBInspectable UIFont *placeholderFont;
/**
 *textFieldt占位符颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
/**
 *代理
 */
@property (nonatomic, weak) id<QLBaseSearchBarDelegate> extenDelegate;
@end
