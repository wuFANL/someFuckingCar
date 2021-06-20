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
        
        self.vipTipImgV = [[UIImageView alloc]init];
        [self addSubview:self.vipTipImgV];
        self.vipTipImgV.backgroundColor = [UIColor clearColor];
        self.vipTipImgV.frame = CGRectMake(self.headBtn.x + self.headBtn.width - 13, self.headBtn.y + self.headBtn.height - 13 - 7, 13, 13);
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
   
    
    NSString *stateStr = [QLUserInfoModel getLocalInfo].account.state;
    //审核中  state 99 98
    // 1 就判断flag
    if ([stateStr isEqualToString:@"99"] || [stateStr isEqualToString:@"98"]) {
        // 申请中
        [self.vipStatusBtn setTitle:@"申请中" forState:UIControlStateNormal];
        [self.numBtn setTitle:@"" forState:UIControlStateNormal];
        self.vipTipImgV.image = [UIImage imageNamed:@""];
    } else if ([stateStr isEqualToString:@"99"]) {
        
    } else {
        //    flag=2是全省vip flag=3是全国vip
        //    flag=1是无会员
        NSNumber *vipFlag = [QLUserInfoModel getLocalInfo].personnel.flag;
        //
        if ([vipFlag isEqual:@(2)]) {
            [self.vipStatusBtn setTitle:@"已通过" forState:UIControlStateNormal];
            [self.numBtn setTitle:@"vip" forState:UIControlStateNormal];
            self.vipTipImgV.image = [UIImage imageNamed:@"vip_blue"];
        } else if ([vipFlag isEqual:@(3)]) {
            [self.vipStatusBtn setTitle:@"已通过" forState:UIControlStateNormal];
            [self.numBtn setTitle:@"vip" forState:UIControlStateNormal];
            self.vipTipImgV.image = [UIImage imageNamed:@"vip_orange"];
        } else if ([vipFlag isEqual:@(1)]){
            [self.vipStatusBtn setTitle:@"非会员" forState:UIControlStateNormal];
            [self.numBtn setTitle:@"" forState:UIControlStateNormal];
            self.vipTipImgV.image = [UIImage imageNamed:@""];
        } else {
            [self.vipStatusBtn setTitle:@"会员待审" forState:UIControlStateNormal];
            [self.numBtn setTitle:@"" forState:UIControlStateNormal];
            self.vipTipImgV.image = [UIImage imageNamed:@""];
        }
        
    }
    
    
   
    
}

@end
