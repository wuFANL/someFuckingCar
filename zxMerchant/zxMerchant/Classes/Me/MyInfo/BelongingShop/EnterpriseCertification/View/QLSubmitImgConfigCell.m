//
//  QLSubmitImgConfigCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/30.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLSubmitImgConfigCell.h"

@implementation QLSubmitImgConfigCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithStaff:(BOOL)isStaff andIndexPath:(NSInteger)index{
    // 展示身份证图片
    if (isStaff) {
        
        if (index == 1) {
            self.bTitleLB.text = @"身份证正面";
            self.bImgView.image = [UIImage imageNamed:@"ID_card_front"];
        } else {
            self.bTitleLB.text = @"身份证背面";
            self.bImgView.image = [UIImage imageNamed:@"ID_card_back"];
        }
    } else {
        self.bTitleLB.hidden = @"内容";
        self.bImgView.image = [UIImage imageNamed:@"addImage"];
    }
}

@end
