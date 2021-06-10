//
//  QLCarCellDtlCell.m
//  zxMerchant
//
//  Created by HK on 2021/6/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLCarCellDtlCell.h"

@implementation QLCarCellDtlCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImg roundRectCornerRadius:6.0 borderWidth:1.0 borderColor:[UIColor whiteColor]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
