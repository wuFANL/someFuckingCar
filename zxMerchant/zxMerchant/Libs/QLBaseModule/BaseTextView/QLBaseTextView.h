//
//  QLBaseTextView.h
//  QLKit
//
//  Created by 乔磊 on 2018/3/19.
//  Copyright © 2018年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class UITextViewWorkaround;
@class QLBaseTextView;
@protocol QLBaseTextViewDelegate <NSObject>
@optional
- (BOOL)textViewWillEditing:(UITextView *)textView;
- (void)textViewTextChange:(UITextView *)textView;
@end
@interface QLBaseTextView : UITextView
/*
 *占位控件
 */
@property (nonatomic, strong) UILabel *placeholderLB;
/*
 *限制文本控件
 */
@property (nonatomic, strong) UILabel *constraintLB;
/*
 *占位文本
 */
@property (nonatomic, strong) IBInspectable NSString *placeholder;
/*
 *字数限制(0为不限制)
 */
@property (nonatomic, assign) NSInteger countLimit;
/*
 *是否显示占位文本
 */
@property (nonatomic, assign) IBInspectable BOOL showPlaceholder;
/*
 *是否显示字数限制进度文本
 */
@property (nonatomic, assign) IBInspectable BOOL showCountLimit;
/**
 *占位文本是否居中显示
 */
@property (nonatomic, assign) IBInspectable BOOL showCenterPlaceholder;
/*
 *是否显示长按菜单
 */
@property (nonatomic, assign) BOOL showMenu;
/**
 *代理
 */
@property (nonatomic, weak) id<QLBaseTextViewDelegate> tvDelegate;

@end

@interface UITextViewWorkaround : NSObject
/**
 *解决Xcode 不能读取textView xib 崩溃
 */
+ (void)executeWorkaround;
@end
