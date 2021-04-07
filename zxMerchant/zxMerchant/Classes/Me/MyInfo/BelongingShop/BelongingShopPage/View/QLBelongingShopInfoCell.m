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

@end
