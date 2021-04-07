//
//  QLTopCarSourcePriceCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/24.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLTopCarSourcePriceCell.h"

@implementation QLTopCarSourcePriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pifaPrice = @"0.0";
    
    [self.chatPriceBtn roundRectCornerRadius:28*0.5 borderWidth:1 borderColor:ClearColor];
}
#pragma mark - setter
- (void)setPifaPrice:(NSString *)pifaPrice {
    _pifaPrice = pifaPrice;
    if (pifaPrice.length != 0) {
        NSString *content = [NSString stringWithFormat:@"批发%@万",pifaPrice];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:204/255.0 green:153/255.0 blue:102/255.0 alpha:1.0]}];
        [attStr addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 24]} range:[content rangeOfString:pifaPrice]];
        self.pifaLB.attributedText = attStr;
    }
}
- (void)setLingshouPrice:(NSString *)lingshouPrice {
    _lingshouPrice = lingshouPrice;
    if (lingshouPrice.length != 0) {
        NSString *content = [NSString stringWithFormat:@"零售价%@万",lingshouPrice];
        self.lingshouLB.text = content;
    }
}
@end
