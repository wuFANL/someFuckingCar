//
//  QLAddCarPopWIndow.m
//  zxMerchant
//
//  Created by 张精申 on 2021/6/2.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLAddCarPopWIndow.h"

@implementation QLAddCarPopWIndow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLAddCarPopWIndow viewFromXib];
        self.reSetPriceTextField.rightViewMode = UITextFieldViewModeAlways;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, self.reSetPriceTextField.height)];
        label.text = @"万元  ";
        self.reSetPriceTextField.rightView = label;
        
        self.reSetPriceTextField.layer.cornerRadius = 8;
        self.reSetPriceTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.reSetPriceTextField.layer.borderWidth = 1;
        self.reSetPriceTextField.userInteractionEnabled = YES;
        
        self.detailDesc.layer.cornerRadius = 8;
        self.detailDesc.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.detailDesc.layer.borderWidth = 1;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
