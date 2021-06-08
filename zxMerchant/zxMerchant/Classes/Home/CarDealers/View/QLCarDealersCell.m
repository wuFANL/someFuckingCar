//
//  QLCarDealersCell.m
//  zxMerchant
//
//  Created by lei qiao on 2021/6/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLCarDealersCell.h"

@implementation QLCarDealersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.gzBtn roundRectCornerRadius:25*0.5 borderWidth:1 borderColor:ClearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
