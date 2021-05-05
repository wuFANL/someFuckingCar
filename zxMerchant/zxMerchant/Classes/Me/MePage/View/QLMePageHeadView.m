//
//  QLMePageHeadView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLMePageHeadView.h"

@implementation QLMePageHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLMePageHeadView viewFromXib];
        self.headBtn.imageView.layer.masksToBounds = YES;
        self.headBtn.imageView.layer.cornerRadius = self.headBtn.imageView.width / 2;
        self.storeInvitationBtn.hidden = YES;
    }
    return self;
}

- (void)updateData:(NSDictionary *)data {
    
    
    [self.nikenameBtn setTitle:EncodeStringFromDic([data objectForKey:@"m_account"], @"nickname") forState:UIControlStateNormal];
    
    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:EncodeStringFromDic([data objectForKey:@"m_account"], @"head_pic")] forState:UIControlStateNormal];
    
    self.aNumLB.text = EncodeStringFromDic(data, @"visit_count");
    self.bNumLB.text = EncodeStringFromDic(data, @"help_sell_count");
    self.cNumLB.text = EncodeStringFromDic(data, @"subscribe_count");
//    business_name
    [self.storeNameBtn setTitle:[QLUserInfoModel getLocalInfo].business.business_name forState:UIControlStateNormal];
    
//    flag=2是全省vip flag=3是全国vip
//    flag=1是无会员
    
}

@end
