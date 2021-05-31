//
//  QLConditionsItem.m
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/6/11.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLConditionsItem.h"

@implementation QLConditionsItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setShowDeleteBtn:(BOOL)showDeleteBtn {
    _showDeleteBtn = showDeleteBtn;
    if (showDeleteBtn) {
        self.deleteBtn.hidden = NO;
        self.deleteBtnWidth.constant = 18;
        self.deleteLeftSpace.constant = 8;
    } else {
        self.deleteBtn.hidden = YES;
        self.deleteBtnWidth.constant = 0;
        self.deleteLeftSpace.constant = 0;
    }
}
@end
