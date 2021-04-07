//
//  QLUpdateVedioCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/16.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLUpdateVedioCell.h"

@implementation QLUpdateVedioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.uploadControl roundRectCornerRadius:4 borderWidth:1 borderColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
