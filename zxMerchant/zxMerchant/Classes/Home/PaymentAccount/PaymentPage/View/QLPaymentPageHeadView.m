//
//  QLPaymentPageHeadView.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/27.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLPaymentPageHeadView.h"
@interface QLPaymentPageHeadView()
@property (nonatomic, weak) UIButton *selectBtn;

@end

@implementation QLPaymentPageHeadView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLPaymentPageHeadView viewFromXib];
        self.selectBtn = self.aBtn;
    }
    return self;
}
- (void)setModel:(QLPaymentPageModel *)model {
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.merchant_account.alipay_url]];
    
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.selectBtn != sender) {
        self.selectBtn.selected = NO;
        sender.selected = YES;
        self.selectBtn = sender;
        if (self.selectBtn.tag == 0) {
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.model.merchant_account.alipay_url]];
        } else {
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.model.merchant_account.weixpay_url]];
        }
    }
}


@end
