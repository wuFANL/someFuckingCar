//
//  QLDueProcessCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/10.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLDueProcessCell.h"

@implementation QLDueProcessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.doBtn roundRectCornerRadius:self.doBtn.height*0.5 borderWidth:1 borderColor:GreenColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
