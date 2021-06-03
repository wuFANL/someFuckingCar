//
//  QLAddCarPopWIndow.m
//  zxMerchant
//
//  Created by 张精申 on 2021/6/2.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLAddCarPopWIndow.h"

@implementation QLAddCarPopWIndow

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLAddCarPopWIndow viewFromXib];
        self.reSetPriceTextField.rightViewMode = UITextFieldViewModeAlways;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, self.reSetPriceTextField.height)];
        label.text = @"万元  ";
        self.reSetPriceTextField.rightView = label;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.reSetPriceTextField.height)];
        self.reSetPriceTextField.leftView = leftView;
        self.reSetPriceTextField.leftViewMode = UITextFieldViewModeAlways;
        self.reSetPriceTextField.layer.cornerRadius = 8;
        self.reSetPriceTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.reSetPriceTextField.layer.borderWidth = 1;
        self.reSetPriceTextField.userInteractionEnabled = YES;
        
        self.detailDesc.layer.cornerRadius = 8;
        self.detailDesc.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.detailDesc.layer.borderWidth = 1;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [self.sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cancleButton addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    return self;
    
}

- (void)sureAction {
    if (self.sureBlock) {
        self.sureBlock(self.reSetPriceTextField.text,self.detailDesc.text);
    }
}

- (void)cancleAction {
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

@end
