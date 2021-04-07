//
//  QLVipAuditView.h
//  zxMerchant
//
//  Created by lei qiao on 2021/2/16.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLRechargeView.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLVipAuditView : QLBaseView
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet QLBaseButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusAccLB;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnBottom;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (nonatomic, strong) QLRechargeView *rView;
- (void)show;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
