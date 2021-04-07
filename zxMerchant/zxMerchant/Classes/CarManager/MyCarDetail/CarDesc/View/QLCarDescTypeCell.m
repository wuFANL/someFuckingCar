//
//  QLCarDescTypeCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/16.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLCarDescTypeCell.h"
@interface QLCarDescTypeCell()
@property (nonatomic, weak) UIButton  *currentBtn;
@end
@implementation QLCarDescTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)typeBtnClick:(UIButton *)sender {
    if (self.currentBtn != sender) {
        sender.selected = YES;
        self.currentBtn.selected = NO;
        self.currentBtn = sender;
    }
    NSInteger index = sender.tag;
    self.handler(@(index));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
