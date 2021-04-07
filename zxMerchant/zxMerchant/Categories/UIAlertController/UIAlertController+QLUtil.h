//
//  UIAlertController+QLUtil.h
//  MoneyTree
//
//  Created by 乔磊 on 2017/12/27.
//  Copyright © 2017年 gengjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (QLUtil)
/*
 *类方法调用
 *@param  style          UIAlertControllerStyle
 *@param  title          标题
 *@param  detail         描述
 *@param  DefaultTitle   确定标题
 *@param  cancelTitle    取消标题
 *@param  vc             当前控制器
 *@param  defaultAction  确定的点击回调
 *@param  cancelAction   取消的点击回调
 */
+ (UIAlertController *)showAlertController:(UIAlertControllerStyle)style Title:(NSString *)title DetailTitle:(NSString *)detail DefaultTitle:(NSArray <NSString *>*)defaultTitle CancelTitle:(NSString *)cancelTitle Delegate:(id)vc DefaultAction:(void(^)(NSString *selectedTitle))defaultAction CancelAction:(void (^)(void))cancelAction;
/**
 *文字颜色
 */
- (void)setActionTextColor:(UIColor *)textColor;
@end
