//
//  QLCarCircleHeadView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/20.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLBannerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLCarCircleHeadView : UIView
@property (weak, nonatomic) IBOutlet QLBannerView *bannerView;
@property (weak, nonatomic) IBOutlet QLBaseButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet QLBaseButton *storeNameBtn;

@end

NS_ASSUME_NONNULL_END
