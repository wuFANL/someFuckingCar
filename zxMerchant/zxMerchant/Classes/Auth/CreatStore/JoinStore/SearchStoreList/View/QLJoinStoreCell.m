//
//  QLJoinStoreCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLJoinStoreCell.h"

@implementation QLJoinStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(IBAction)actionSelectedCell:(id)sender
{
    if(self.selectedBlock)
    {
        self.selectedBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
