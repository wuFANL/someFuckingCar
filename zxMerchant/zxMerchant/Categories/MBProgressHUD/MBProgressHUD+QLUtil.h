//
//  MBProgressHUD+perfect.h
//  Pods
//
//  Created by jgs on 2017/6/20.
//
//

#import <MBProgressHUD/MBProgressHUD.h>
#import <UIKit/UIKit.h>
@interface MBProgressHUD (QLUtil)

#pragma mark- MBProgressHUD在指定view上添加
/*
 *MBProgressHUD菊花加载
 */
+ (void)showLoading:(NSString *)title inView:(UIView *)view;
/*
 *MBProgressHUD自定义动画加载
 */
+ (void)showCustomLoading:(NSString *)title inView:(UIView *)view;
/*
 *MBProgressHUD显示自定义成功或者失败，默认时间消失
 */
+ (void)showSuccess:(NSString *)title inView:(UIView *)view;
+ (void)showError:(NSString *)title inView:(UIView *)view;
/*
 *MBProgressHUD显示自定义成功或者失败指定时间消失
 */
+ (void)showSuccess:(NSString *)title inView:(UIView *)view disapperTime:(CGFloat)time;
+ (void)showError:(NSString *)title inView:(UIView *)view disapperTime:(CGFloat)time;
/*
 *MBProgressHUD立即消失
 */
+ (void)immediatelyRemoveHUDInView:(UIView *)view;
/*
 *MBProgressHUD默认时间消失
 */
+ (void)defalutRemoveHUDInView:(UIView *)view;
/**
 *指定视图上的MBProgressHUD指定时间消失
 */
+ (void)MBProgressHUDHide:(UIView *)view AfterDelay:(CGFloat)time;


#pragma mark- MBProgressHUD在keywindow上添加
/**
 *MBProgressHUD菊花加载
 */
+ (void)showLoading:(NSString *)title;
/**
 *MBProgressHUD自定义动画加载
 */
+ (void)showCustomLoading:(NSString *)title;
/**
 *MBProgressHUD显示成功或者失败默认消失
 */
+ (void)showSuccess:(NSString *)title;
+ (void)showError:(NSString *)title;
/**
 *MBProgressHUD显示成功或者失败指定时间消失
 */
+ (void)showSuccess:(NSString *)title disapperTime:(CGFloat)time;
+ (void)showError:(NSString *)title disapperTime:(CGFloat)time;
/**
 *MBProgressHUD默认时间消失
 */
+ (void)defalutRemoveHUD;
/**
 *MBProgressHUD立即消失
 */
+ (void)immediatelyRemoveHUD;
/**
 *MBProgressHUD指定时间消失
 */
+ (void)MBProgressHUDHideAfterDelay:(CGFloat)time;
@end
