//
//  QLCooperativeSourceDetailBottomView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/18.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCooperativeSourceDetailBottomView.h"

@implementation QLCooperativeSourceDetailBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLCooperativeSourceDetailBottomView viewFromXib];
        
        [self setShadowPathWith:LightGrayColor shadowOpacity:1 shadowRadius:1 shadowSide:QLShadowPathTop shadowPathWidth:1];
        [self.moreBtn roundRectCornerRadius:4 borderWidth:1 borderColor:GreenColor];
    }
    return self;
}

@end
