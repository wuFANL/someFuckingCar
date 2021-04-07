//
//  QLCreatStoreTVCell.m
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/21.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLCreatStoreTVCell.h"

@implementation QLCreatStoreTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tv roundRectCornerRadius:2 borderWidth:0.5 borderColor:ClearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
