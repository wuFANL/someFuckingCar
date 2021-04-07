//
//  QLCarDetailPriceCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/27.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarDetailPriceCell.h"

@implementation QLCarDetailPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.reduceBtn roundRectCornerRadius:3 borderWidth:1 borderColor:GreenColor];
    [self.internalPriceBtn roundRectCornerRadius:3 borderWidth:1 borderColor:GreenColor];
    
    self.contactBtn.hidden = YES;
    self.reduceBtn.hidden = YES;
    self.internalPriceBtn.hidden = YES;
}


@end
