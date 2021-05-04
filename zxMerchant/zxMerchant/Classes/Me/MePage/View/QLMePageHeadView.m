//
//  QLMePageHeadView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLMePageHeadView.h"

@implementation QLMePageHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLMePageHeadView viewFromXib];
        
    }
    return self;
}

- (void)updateData:(NSDictionary *)data {
    
}

@end
