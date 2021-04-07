//
//  QLVipCenterHeadView.m
//  zxMerchant
//
//  Created by lei qiao on 2021/1/10.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLVipCenterHeadView.h"

@implementation QLVipCenterHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLVipCenterHeadView viewFromXib];
        
        [self.invitationBtn roundRectCornerRadius:15 borderWidth:1 borderColor:ClearColor];
        
    }
    return self;
}

@end
