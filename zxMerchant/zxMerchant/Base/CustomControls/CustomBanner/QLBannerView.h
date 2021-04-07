//
//  QLBannerView.h
//  TheOneCampus
//
//  Created by 乔磊 on 2017/8/8.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QLBannerView;
@protocol QLBannerViewDelegate <NSObject>
@optional
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn;
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr CurrentPage:(NSInteger)currentPage;
- (void)bannerView:(QLBannerView *)bannerView ImageClick:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn;
@end

@interface QLBannerView : UIView
/**
 *初始化
 */
- (instancetype)initWithFrame:(CGRect)frame HavePageControl:(BOOL)havePage Delegate:(id<QLBannerViewDelegate>)currentSelf;
/*
 *设置PageControl未点中图片
 */
@property (nonatomic, strong) UIImage *defaultPageImage;
/*
 *设置PageControl点中图片
 */
@property (nonatomic, strong) UIImage *currentPageImage;
/*
 *数据数组
 */
@property (nonatomic, strong) NSArray *imagesArr;
/*
 *是否有分页点
 */
@property (nonatomic, assign) BOOL havePage;
/*
 *分页点
 */
@property (nonatomic, strong) QLBasePageControl *pageControl;
/**
 *image点击
 */
@property (nonatomic, weak) id<QLBannerViewDelegate> delegate;
@end
