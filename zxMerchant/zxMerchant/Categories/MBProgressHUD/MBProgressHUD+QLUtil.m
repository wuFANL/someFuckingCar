//
//  MBProgressHUD+perfect.m
//  Pods
//
//  Created by jgs on 2017/6/20.
//
//

#import "MBProgressHUD+QLUtil.h"
#define HUDDefaultShowTime 2

@interface MBProgressHUD()
//gif图片
@property (nonatomic, weak) UIImageView *ImageView;
@end
@implementation MBProgressHUD (QLUtil)
#pragma mark- MBProgressHUD 自定义视图透明背景为tag值110的，其他为默认黑色
//添加MBProgressHUD系统
+ (MBProgressHUD *)MBProgressHUDAddSubview:(UIView *)view Style:(MBProgressHUDMode)style CustomView:(UIView *)customView Title:(NSString *)title {
    if (view == nil){
        if ([UIApplication sharedApplication].keyWindow) {
            view = [UIApplication sharedApplication].keyWindow;
        } else {
            return nil;
        }
    } ;
    if ([self HUDForView:view] != nil) {
        [[self HUDForView:view] hideAnimated:YES];
        [[self HUDForView:view] removeFromSuperViewOnHide];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = style;
    hud.minSize = CGSizeMake(120, 30);
    hud.label.text = title;
    hud.offset = CGPointMake(0, -20);
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.tintColor = [UIColor blackColor];
    [hud setContentColor:[UIColor whiteColor]];
    
    //消失方式
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.removeFromSuperViewOnHide = YES;
    //设置自定义视图
    if (style == MBProgressHUDModeCustomView&&customView != nil) {
        hud.customView = customView;
    }
    //设置背景
    [self setBezelViewColor:hud];
    
    return hud;
}
+ (void)setBezelViewColor:(MBProgressHUD *)hud {
    if (hud.customView.tag == 110) {
        //透明背景
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor clearColor];
        hud.bezelView.backgroundColor = [UIColor clearColor];
    } else {
        //默认背景
        hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
        hud.bezelView.color = [UIColor blackColor];
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.bezelView.alpha = 0.8;
    }
}
//MBProgressHUD自定义显示成功或者失败视图
+ (UIView *)customViewSuccess {
    UIImageView *customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/success"]];
    return customView;
}
+ (UIView *)customViewError {
    UIImageView *customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/error"]];
    return customView;
}
// MBProgressHUD自定义加载动画
+ (UIView *)customViewLoad {
    UIImageView *gifImageView = [[UIImageView alloc] init];
    NSString  *filePath = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    gifImageView.image = [UIImage sd_imageWithGIFData:imageData];
    gifImageView.contentMode = UIViewContentModeScaleAspectFit;
    gifImageView.tag = 110;
    return gifImageView;
}
#pragma mark- MBProgressHUD在指定view上添加
//MBProgressHUD菊花加载
+ (void)showLoading:(NSString *)title inView:(UIView *)view {
    [self MBProgressHUDAddSubview:view Style:MBProgressHUDModeIndeterminate CustomView:nil Title:title];
}
//MBProgressHUD自定义动画加载
+ (void)showCustomLoading:(NSString *)title inView:(UIView *)view {
    [self MBProgressHUDAddSubview:view Style:MBProgressHUDModeCustomView CustomView:[self customViewLoad] Title:title];
}
//MBProgressHUD显示自定义成功或者失败，默认时间消失
+ (void)showSuccess:(NSString *)title inView:(UIView *)view {
    [self MBProgressHUDAddSubview:view Style:MBProgressHUDModeCustomView CustomView:[self customViewSuccess] Title:title];
    [self defalutRemoveHUDInView:view];
}
+ (void)showError:(NSString *)title inView:(UIView *)view {
    [self MBProgressHUDAddSubview:view Style:MBProgressHUDModeCustomView CustomView:[self customViewError] Title:title];
    [self defalutRemoveHUDInView:view];
}
//MBProgressHUD显示自定义成功或者失败,指定时间消失
+ (void)showSuccess:(NSString *)title inView:(UIView *)view disapperTime:(CGFloat)time {
    [self MBProgressHUDAddSubview:view Style:MBProgressHUDModeCustomView CustomView:[self customViewSuccess] Title:title];
    [self MBProgressHUDHide:view AfterDelay:time];
    
}
+ (void)showError:(NSString *)title inView:(UIView *)view disapperTime:(CGFloat)time {
    [self MBProgressHUDAddSubview:view Style:MBProgressHUDModeCustomView CustomView:[self customViewError] Title:title];
    [self MBProgressHUDHide:view AfterDelay:time];
}
//MBProgressHUD立即消失
+ (void)immediatelyRemoveHUDInView:(UIView *)view  {
    [self MBProgressHUDHide:view AfterDelay:0];
}
//MBProgressHUD默认时间消失
+ (void)defalutRemoveHUDInView:(UIView *)view {
    [self MBProgressHUDHide:view AfterDelay:HUDDefaultShowTime];
}
//指定视图上MBProgressHUD指定时间消失
+ (void)MBProgressHUDHide:(UIView *)view AfterDelay:(CGFloat)time {
    if (view == nil) {
        if ([UIApplication sharedApplication].keyWindow) {
            view = [UIApplication sharedApplication].keyWindow;
        } else {
            return;
        }
    } ;
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [self HUDForView:view];
        [hud hideAnimated:YES afterDelay:time];
        [hud removeFromSuperViewOnHide];
    });
    
}
#pragma mark- MBProgressHUD在keywindow上添加
//MBProgressHUD菊花加载
+ (void)showLoading:(NSString *)title {
    [self MBProgressHUDAddSubview:[UIApplication sharedApplication].keyWindow Style:MBProgressHUDModeIndeterminate CustomView:nil Title:title];
}
//MBProgressHUD自定义动画加载
+ (void)showCustomLoading:(NSString *)title {
    [self MBProgressHUDAddSubview:[UIApplication sharedApplication].keyWindow Style:MBProgressHUDModeCustomView CustomView:[self customViewLoad] Title:title];
}
//MBProgressHUD显示自定义成功或者失败,默认时间消失
+ (void)showSuccess:(NSString *)title {
    [self MBProgressHUDAddSubview:[UIApplication sharedApplication].keyWindow Style:MBProgressHUDModeCustomView CustomView:[self customViewSuccess] Title:title];
    [self defalutRemoveHUD];
}
+ (void)showError:(NSString *)title {
    [self MBProgressHUDAddSubview:[UIApplication sharedApplication].keyWindow Style:MBProgressHUDModeCustomView CustomView:[self customViewError] Title:title];
    [self defalutRemoveHUD];
}
//MBProgressHUD显示自定义成功或者失败,指定时间消失
+ (void)showSuccess:(NSString *)title disapperTime:(CGFloat)time {
    [self MBProgressHUDAddSubview:[UIApplication sharedApplication].keyWindow Style:MBProgressHUDModeCustomView CustomView:[self customViewSuccess] Title:title];
    [self MBProgressHUDHide:[UIApplication sharedApplication].keyWindow AfterDelay:time];
    
}
+ (void)showError:(NSString *)title disapperTime:(CGFloat)time {
    [self MBProgressHUDAddSubview:[UIApplication sharedApplication].keyWindow Style:MBProgressHUDModeCustomView CustomView:[self customViewError] Title:title];
    [self MBProgressHUDHide:[UIApplication sharedApplication].keyWindow AfterDelay:time];
}
//MBProgressHUD立即消失
+ (void)immediatelyRemoveHUD {
    [self MBProgressHUDHide:[UIApplication sharedApplication].keyWindow AfterDelay:0];
}
//MBProgressHUD默认时间消失
+ (void)defalutRemoveHUD {
    [self MBProgressHUDHide:[UIApplication sharedApplication].keyWindow AfterDelay:HUDDefaultShowTime];
}
//MBProgressHUD指定时间消失
+ (void)MBProgressHUDHideAfterDelay:(CGFloat)time {
    [self MBProgressHUDHide:[UIApplication sharedApplication].keyWindow AfterDelay:time];
}

@end
