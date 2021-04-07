//
//  QLContactsDescCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/10.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLContactsDescCell.h"

@implementation QLContactsDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionBtn.hidden = YES;
    [self.collectionBtn roundRectCornerRadius:2 borderWidth:1 borderColor:[UIColor colorWithHexString:@"#959595"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
