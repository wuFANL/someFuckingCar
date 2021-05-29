//
//  QLEidtPayCodeCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/28.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLEidtPayCodeCell.h"

@implementation QLEidtPayCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.deleteBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
