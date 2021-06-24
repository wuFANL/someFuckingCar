//
//  QLHomeCarItem.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/3.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLHomeCarItem.h"

@implementation QLHomeCarItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.carImgView.clipsToBounds = YES;
}

- (void)updateWithDic:(NSDictionary *)dic {
    
    if (dic) {
        [self.carImgView sd_setImageWithURL:[NSURL URLWithString:EncodeStringFromDic(dic, @"car_img")]];
        self.nameLB.text = EncodeStringFromDic(dic, @"model");
        self.yearLB.text = EncodeStringFromDic(dic, @"update_time");
        
        if ([[QLUserInfoModel getLocalInfo].account.state isEqualToString:@"1"]) {
            self.priceLB.text = [NSString stringWithFormat:@"批发价%@",[[QLToolsManager share] unitConversion:[EncodeStringFromDic(dic, @"wholesale_price") floatValue]]];
        } else {
            self.priceLB.text = [NSString stringWithFormat:@"批发价X万"];
        }
    }
}

@end
