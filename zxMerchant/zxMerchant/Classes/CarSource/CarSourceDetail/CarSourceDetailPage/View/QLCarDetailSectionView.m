//
//  QLCarDetailSectionView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/27.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarDetailSectionView.h"

@implementation QLCarDetailSectionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLCarDetailSectionView viewFromXib];
        
        [self.editBtn roundRectCornerRadius:3 borderWidth:1 borderColor:GreenColor];
        self.editBtn.hidden = YES;
        self.collectBtn.hidden = YES;
        self.moreBtn.hidden = YES;
        
    }
    return self;
}

@end
