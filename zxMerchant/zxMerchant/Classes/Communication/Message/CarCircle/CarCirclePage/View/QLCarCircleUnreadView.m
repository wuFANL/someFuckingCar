//
//  QLCarCircleUnreadView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/20.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarCircleUnreadView.h"

@implementation QLCarCircleUnreadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLCarCircleUnreadView viewFromXib];
        [self.msgControl roundRectCornerRadius:2 borderWidth:1 borderColor:WhiteColor];
        [self.headBtn roundRectCornerRadius:2 borderWidth:1 borderColor:ClearColor];
        
    }
    return self;
}

@end
