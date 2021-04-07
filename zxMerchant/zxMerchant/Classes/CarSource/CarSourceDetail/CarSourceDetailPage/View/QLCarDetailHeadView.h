//
//  QLCarDetailHeadView.h
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/4/24.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLBannerView.h"

@class QLCarDetailHeadView;
@protocol QLCarDetailHeadViewDelegate <NSObject>
@optional
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr Index:(NSInteger)index;
@end
@interface QLCarDetailHeadView : UIView
@property (weak, nonatomic) IBOutlet QLBaseButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *progressLB;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

/*
 *轮播图数据
 */
@property (nonatomic, strong) NSArray *bannerArr;
/**
 *代理
 */
@property (nonatomic, weak) id<QLCarDetailHeadViewDelegate> delegate;
@end
