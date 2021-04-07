//
//  QLContentTFCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/10/21.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLContentTFCell.h"

@implementation QLContentTFCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTF.borderStyle = UITextBorderStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
