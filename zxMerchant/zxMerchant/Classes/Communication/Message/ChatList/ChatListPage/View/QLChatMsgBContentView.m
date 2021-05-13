//
//  QLChatMsgBContentView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLChatMsgBContentView.h"

@implementation QLChatMsgBContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLChatMsgBContentView viewFromXib];
        
        [self.cancelBtn roundRectCornerRadius:4 borderWidth:1 borderColor:GreenColor];
    }
    return self;
}

-(IBAction)actionTapBtn:(UIButton *)sender
{
    if(self.tapBlock)
    {
        self.tapBlock(sender.tag);
    }
}

@end
