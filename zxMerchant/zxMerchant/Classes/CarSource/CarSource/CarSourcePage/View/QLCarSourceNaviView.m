//
//  QLCarSourceNaviView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/17.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarSourceNaviView.h"

@implementation QLCarSourceNaviView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLCarSourceNaviView viewFromXib];
        
        self.searchBar.noEditClick = YES;
    }
    return self;
}

@end
