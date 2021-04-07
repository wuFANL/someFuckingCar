//
//  QLContactsStoreCarCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLContactsStoreCarCell.h"

@implementation QLContactsStoreCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isEditing = NO;
}
- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    if (isEditing) {
        self.selectBtn.hidden = NO;
        self.selectBtnWidth.constant = 40;
        
    } else {
        self.selectBtn.hidden = YES;
        self.selectBtnWidth.constant = 0;
    }
}
- (void)setSelectStatus:(BOOL)selectStatus {
    _selectStatus = selectStatus;
    self.selectBtn.selected = selectStatus;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
