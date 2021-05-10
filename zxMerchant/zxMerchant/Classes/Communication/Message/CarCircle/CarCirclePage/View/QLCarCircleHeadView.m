//
//  QLCarCircleHeadView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/20.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarCircleHeadView.h"

@implementation QLCarCircleHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLCarCircleHeadView viewFromXib];
        
        [self.headBtn roundRectCornerRadius:3 borderWidth:1 borderColor:ClearColor];
    }
    return self;
}

@end
