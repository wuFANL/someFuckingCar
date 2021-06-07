//
//  QLVipPriceItem.m
//  zxMerchant
//
//  Created by lei qiao on 2021/1/19.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLVipPriceItem.h"

@implementation QLVipPriceItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)upDateWithDic:(NSDictionary *)dic{
    self.timeLB.text = EncodeStringFromDic(dic, @"extend_03");
    self.priceLB.text = [NSString stringWithFormat:@"￥%@",EncodeStringFromDic(dic, @"value")];
    
    NSString * oldPrice = [NSString stringWithFormat:@"原价%@",EncodeStringFromDic(dic, @"extend_01")];
    NSUInteger length = oldPrice.length;
    NSMutableAttributedString * attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [self.oldPriceLB setAttributedText:attri];
}

@end
