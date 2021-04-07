//
//  MJDIYBackFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYBackFooter.h"

@interface MJDIYBackFooter()
@property (weak, nonatomic) UILabel *label;
//@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation MJDIYBackFooter
#pragma mark-  重写方法

#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 50;
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    // logo
//    UIImageView *logo = [[UIImageView alloc] init];
//    logo.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:logo];
//    self.logo = logo;
//    [self createImageViewAnimation:32 frameImageName:@"dropdown_anim__000" animateDuration:1.0/10 repeatCount:0];
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.hidden = YES;
    [self addSubview:loading];
    self.loading = loading;
}
//-(void)createImageViewAnimation:(NSInteger)frameCount frameImageName:(NSString*)frameImageName animateDuration:(CGFloat)duration repeatCount:(NSInteger)repeatCount{
//    //UIImageView动画
//    //自己创建所需的 UIImage 让后通过 UIImageView来显示动画
//    //创建保存动画 image 的数组
//    NSMutableArray *allImage = [NSMutableArray array];
//    //通过循环 创建UIImage实例(每一帧) 并且添加到数组中
//    for (int i = 0; i < frameCount; i++) {
//        //拼接每一帧的名字
//        NSString *imageName = [NSString stringWithFormat:@"%@%d",frameImageName, i+1];
//        //创建UIImage实例
//        UIImage *image = [UIImage imageNamed:imageName];
//        //将UIImage实例添加到数组中
//        [allImage addObject:image];
//    }
//    //设置imageview做动画所需的所以UIImage， 通过数组设置
//    self.logo.animationImages = allImage;
//    
//    
//    //设置imageView做动画所需时间 （1次动画的时间）
//    //  1/3  int 0
//    //  1.0 / 3  float  0.3333333 (隐式类型转换)
//    self.logo.animationDuration = duration * frameCount;
//    //设置动画执行次数 (0表示无限执行)
//    self.logo.animationRepeatCount = repeatCount;
//    //开始动画
//    [self.logo startAnimating];
//    
//    //如果不是一直重复播放， 在播放完成时， 释放图片
//    if (repeatCount != 0) {
//        //动画结束时 释放掉图片
//        //动画运行2次后，释放动画用的图片
//        [self.logo performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.logo.animationDuration * repeatCount];
//    }
//}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = self.bounds;
//    self.logo.bounds = CGRectMake(0, 0, 50, 50);
//    self.logo.center = CGPointMake(25, self.mj_h* 0.5);
    self.loading.center = CGPointMake(80, self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.loading.hidden = YES;
            [self.loading stopAnimating];
            self.label.text = @"上拉加载更多";
            break;
        case MJRefreshStatePulling:
            self.loading.hidden = YES;
            [self.loading stopAnimating];
            self.label.text = @"松开立即加载";
            break;
        case MJRefreshStateRefreshing:
            self.loading.hidden = NO;
            [self.loading startAnimating];
            self.label.text = @"正在加载更多数据...";
            break;
        case MJRefreshStateNoMoreData:
            self.loading.hidden = YES;
            [self.loading stopAnimating];
            self.label.text = @"——  我是有底线的  ——";
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    self.loading.hidden = YES;
    [self.loading stopAnimating];
  
}

@end
