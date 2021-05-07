//
//  QLChatListHeadItem.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/5.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLChatListHeadItem.h"

@implementation QLChatListHeadItem

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.numLB roundRectCornerRadius:15*0.5 borderWidth:1 borderColor:ClearColor];
}

-(void)showBadge:(NSString *)num
{
    if([num intValue] > 0)
    {
        self.numLB.hidden = NO;
        self.numLB.text = num;
    }
    else
    {
        self.numLB.hidden = YES;
    }
}
@end
