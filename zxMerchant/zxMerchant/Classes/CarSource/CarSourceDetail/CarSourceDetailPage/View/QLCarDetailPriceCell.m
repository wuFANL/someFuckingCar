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

- (void)updateWithDic:(NSDictionary *)dataDic{
    if (dataDic) {
        //批发价wholesale_price  // 销售价wholesale_price_old
        NSString *wholesale_price = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"car_info"] objectForKey:@"wholesale_price"]];
        NSString *wholesale_price_old = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"car_info"] objectForKey:@"wholesale_price_old"]];
        
        self.priceLB.text = [NSString stringWithFormat:@"批发价%@",[[QLToolsManager share] unitConversion:[wholesale_price floatValue]]];
        self.accPriceLB.text = [NSString stringWithFormat:@"零售价:%@",[[QLToolsManager share] unitConversion:[wholesale_price_old floatValue]]];
    }
}

@end
