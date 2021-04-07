//
//  QLCarSourceManagerCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/3.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarSourceManagerCell.h"

@implementation QLCarSourceManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.showFunView = NO;
    
}
#pragma mark - setter
- (void)setShowFunView:(BOOL)showFunView {
    _showFunView = showFunView;
    if (showFunView) {
        self.funView.hidden = NO;
        self.funViewHeight.constant = 20;
    } else {
        self.funView.hidden = YES;
        self.funViewHeight.constant = 0;
    }
}

@end
