//
//  QLEditTopCarItem.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/7.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLEditTopCarItem.h"

@implementation QLEditTopCarItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(IBAction)actionTapBtn:(UIButton *)sender
{
    if(self.tapBlock)
    {
        self.tapBlock(sender);
    }
}


@end
