//
//  QLContactsStoreBottomView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLContactsStoreBottomView.h"

@implementation QLContactsStoreBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLContactsStoreBottomView viewFromXib];
        
        [self.funBtn roundRectCornerRadius:4 borderWidth:1 borderColor:WhiteColor];
        
        self.isEditing = NO;
    }
    return self;
}
- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    if (isEditing) {
        self.allBtn.hidden = NO;
        self.allBtnWidth.constant = 85;
        [self.funBtn setTitle:@"确定" forState:UIControlStateNormal];
    } else {
        self.allBtn.hidden = YES;
        self.allBtnWidth.constant = 0;
        [self.funBtn setTitle:@"选车加入我的车库" forState:UIControlStateNormal];
        
    }
}
@end
