//
//  QLHelpSellCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLHelpSellCell.h"

@implementation QLHelpSellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLB.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateWithDic:(NSDictionary *)dic {
    if (dic) {
//        [self.headBtn sd_setImageWithURL:[NSURL URLWithString:EncodeStringFromDic(dic, @"head_pic")] forState:UIControlStateNormal];
        [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:EncodeStringFromDic(dic, @"head_pic")] forState:UIControlStateNormal];
        self.nameLB.text = EncodeStringFromDic(dic, @"nickname");
        self.descLB.text = EncodeStringFromDic(dic, @"model");

        NSString * state = EncodeStringFromDic(dic, @"state");
        
        //state=-1是全部 0是待洽谈 1是洽谈中 2是已成交
        if ([state isEqualToString:@"0"]) {
            self.statusLB.text = @"待洽谈";
        } else if ([state isEqualToString:@"1"]) {
            self.statusLB.text = @"洽谈中";
        } else {
            self.statusLB.text = @"已成交";
        }
//        unitConversion
        self.priceLB.text =  [[QLToolsManager share] unitConversion:[EncodeStringFromDic(dic, @"deal_price") floatValue]];//;

        [self.imgView sd_setImageWithURL:[NSURL URLWithString:EncodeStringFromDic(dic, @"car_img")]];
    }
}
@end
