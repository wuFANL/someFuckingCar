//
//  QLCarPhotosCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/29.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLCarPhotosCell.h"

@implementation QLCarPhotosCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(QLCarInfoModel *)model {
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.car_img]];
    self.titleLB.text = [NSString stringWithFormat:@"%@ %@ %@",model.brand,model.series,model.model];
    self.priceLB.text = [[QLToolsManager share] unitConversion:model.sell_price.floatValue];
}
- (void)setShowChooseBtn:(BOOL)showChooseBtn {
    _showChooseBtn = showChooseBtn;
    if (showChooseBtn) {
        self.chooseBtn.hidden = NO;
        self.chooseBtnWidth.constant = 20;
    } else {
        self.chooseBtn.hidden = YES;
        self.chooseBtnWidth.constant = 0;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
