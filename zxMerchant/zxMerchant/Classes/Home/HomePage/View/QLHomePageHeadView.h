//
//  QLHomePageHeadView.h
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/24.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLBannerView.h"
#import "QLImgTextItem.h"
NS_ASSUME_NONNULL_BEGIN
@class QLHomePageHeadView;
@protocol QLHomePageHeadViewDelegate <NSObject>
@optional
- (void)funClick:(QLFunModel *)model;

@end
@interface QLHomePageHeadView : UIView
@property (nonatomic, strong) QLBannerView *bannerView;
@property (nonatomic, strong) NSMutableArray *itemArr;
@property (nonatomic, weak) id<QLHomePageHeadViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
