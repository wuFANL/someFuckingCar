//
//  MJDIYHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYHeader.h"

@interface MJDIYHeader()
@property (weak, nonatomic) UIImageView *gifImageView;

@end

@implementation MJDIYHeader
#pragma mark-  重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    //添加动画
    UIImageView *gifImageView = [[UIImageView alloc] init];
    NSString  *filePath = [[NSBundle mainBundle] pathForResource:@"refresh" ofType:@"gif"];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    gifImageView.image = [UIImage sd_imageWithGIFData:imageData];
    gifImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:gifImageView];
    self.gifImageView = gifImageView;
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.gifImageView.frame = self.bounds;
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
            
            break;
        case MJRefreshStatePulling:
            
            break;
        case MJRefreshStateRefreshing:
            
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    if (pullingPercent == 0) {
        
    }
}

@end
