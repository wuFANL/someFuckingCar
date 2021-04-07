//
//  QLVehicleEditPriceCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/12.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLVehicleEditPriceCell.h"

@implementation QLVehicleEditPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tf.borderStyle = UITextBorderStyleNone;
    [self.tfView roundRectCornerRadius:4 borderWidth:1 borderColor:[UIColor groupTableViewBackgroundColor]];
    self.showAccLB = NO;
}
- (void)setShowAccLB:(BOOL)showAccLB {
    _showAccLB = showAccLB;
    if (showAccLB) {
        self.leftAccLB.hidden = NO;
        self.rightAccLB.hidden = NO;
        self.leftAccBottom.constant = 20;
        self.leftAccHeight.constant = 15;
    } else {
        self.leftAccLB.hidden = YES;
        self.rightAccLB.hidden = YES;
        self.leftAccBottom.constant = 0;
        self.leftAccHeight.constant = 0;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
