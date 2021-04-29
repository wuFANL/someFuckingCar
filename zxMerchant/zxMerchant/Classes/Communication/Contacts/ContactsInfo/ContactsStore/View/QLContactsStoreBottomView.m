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
        
        self.cancelBtn.hidden = NO;
        self.cancelBtnRight.constant = 10;
        CGFloat btnWidth = (self.width-85-10-30)/2;
        self.cancelBtnWidth.constant = btnWidth;
        self.funBtnWidth.constant = btnWidth;
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.funBtn setTitle:@"确定" forState:UIControlStateNormal];
        
    } else {
        self.allBtn.hidden = YES;
        self.allBtnWidth.constant = 0;
        
        self.cancelBtn.hidden = YES;
        self.cancelBtnRight.constant = 0;
        self.cancelBtnWidth.constant = 0;
        
        CGFloat btnWidth = self.width-30;
        self.funBtnWidth.constant = btnWidth;
        [self.funBtn setTitle:@"选车加入我的车库" forState:UIControlStateNormal];
    }
}
@end
