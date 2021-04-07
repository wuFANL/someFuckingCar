//
//  UIView+Extension.h
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSInteger{
    QLShadowPathLeft,//左
    QLShadowPathRight,//右
    QLShadowPathTop,//上
    QLShadowPathBottom,//下
    QLShadowPathAllSide//四周
} QLShadowPathSide;

@interface UIView (QLUtil)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
@property (nonatomic ,assign) CGFloat centerX;
@property (nonatomic ,assign) CGFloat centerY;

/**从xib加载和类名一样的view*/
+(instancetype)viewFromXib;
/**当前view是否和window重叠*/
- (BOOL)intersectWithView:(UIView *)view;
/**指定旋转速度，无线旋转当前视图 @param duration 旋转速度*/
- (void)rotate:(NSTimeInterval)duration;
/**画圆*/
- (void)roundBorderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;
/**圆角矩形*/
- (void)roundRectCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth  borderColor:(UIColor*)borderColor;
/**设置阴影*/
- (void)setShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(QLShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth;
/**获取当前View所在控制器*/
- (UIViewController *)getCurrentVCByCurrentView;
@end
