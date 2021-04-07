//
//  QLChatFloatView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/18.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLChatFloatView.h"

@implementation QLChatFloatView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLChatFloatView viewFromXib];
        
        [self.bjView setShadowPathWith:LightGrayColor shadowOpacity:2 shadowRadius:4 shadowSide:QLShadowPathAllSide shadowPathWidth:1];
        [self.headBtn roundRectCornerRadius:30*0.5 borderWidth:1 borderColor:ClearColor];
    }
    return self;
}

@end
