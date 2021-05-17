//
//  QLNewFriendCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/12.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLNewFriendCell.h"

@implementation QLNewFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.collectionBtn roundRectCornerRadius:self.collectionBtn.frame.size.height/2 borderWidth:0.0 borderColor:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)actionAttent:(UIButton *)sender
{
    if(self.btnTBlock)
    {
        self.btnTBlock(sender.tag);
    }
}

@end
