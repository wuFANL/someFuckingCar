//
//  QLBelongingShopInfoCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBelongingShopInfoCell.h"

@implementation QLBelongingShopInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.statusBtn roundRectCornerRadius:2 borderWidth:1 borderColor:ClearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithDic:(NSDictionary *)dic {
    
    NSString *head_pic = EncodeStringFromDic(dic, @"head_pic");
    NSString *monile = EncodeStringFromDic(dic, @"mobile");
    NSString *personnel_nickname = EncodeStringFromDic(dic, @"personnel_nickname");
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:head_pic]];
    self.storeNameLB.text = personnel_nickname;
    self.addressLB.text = monile;
    
    NSString *state = EncodeStringFromDic(dic, @"state");
    
    if ([state isEqualToString:@"1"]) {
        // 已通过审核
        self.statusBtn.hidden = YES;
    } else {
        self.statusBtn.hidden = NO;
        [self.statusBtn setTitle:@"正在审核" forState:UIControlStateNormal];
    }
    
}

@end
