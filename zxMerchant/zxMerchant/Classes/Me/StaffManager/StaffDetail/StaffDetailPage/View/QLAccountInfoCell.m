//
//  QLAccountInfoCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/17.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLAccountInfoCell.h"

@implementation QLAccountInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.showSelectBtn = NO;
}
- (void)setShowSelectBtn:(BOOL)showSelectBtn {
    _showSelectBtn = showSelectBtn;
    if (showSelectBtn) {
        self.selectBtn.hidden = NO;
        self.selectBtnWidth.constant = 24;
        self.titleLeftSpace.constant = 14;
    } else {
        self.selectBtn.hidden = YES;
        self.selectBtnWidth.constant = 0;
        self.titleLeftSpace.constant = 0;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
