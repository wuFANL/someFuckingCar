//
//  QLBrowseDetailCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/31.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBrowseDetailCell.h"

@implementation QLBrowseDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView roundBorderWidth:1 borderColor:ClearColor];
}
- (void)setModel:(QLBrowseDetailModel *)model {
    _model = model;
    if (model) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.head_pic]];
        self.nameLB.text = model.nick_name;
        [self.browseBtn setTitle:[NSString stringWithFormat:@"%@次",model.read_times] forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
