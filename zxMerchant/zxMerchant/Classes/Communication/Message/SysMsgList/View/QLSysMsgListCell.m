//
//  QLSysMsgListCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/11.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLSysMsgListCell.h"

@implementation QLSysMsgListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bjView roundRectCornerRadius:6 borderWidth:1 borderColor:WhiteColor];
    [self.headBtn roundRectCornerRadius:6 borderWidth:1 borderColor:WhiteColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
