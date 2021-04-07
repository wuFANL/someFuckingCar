//
//  QLShareAlertView.h
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/4/2.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLShareAlertView : QLBaseView
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *descLB;
@property (weak, nonatomic) IBOutlet UIButton *coBtn;
@property (nonatomic, strong) ResultBlock handler;
- (void)show;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
