//
//  QLReleaseCarCircleStatusCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/3.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLReleaseCarCircleStatusCell.h"
@interface QLReleaseCarCircleStatusCell()
@property (nonatomic, strong) UIButton *currentBtn;
@end
@implementation QLReleaseCarCircleStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.currentBtn != sender) {
        self.currentBtn.selected = NO;
        sender.selected = YES;
        self.currentBtn = sender;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
