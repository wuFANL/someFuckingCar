//
//  QLDynamicSendMsgBottomView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLDynamicSendMsgBottomView.h"
@interface QLDynamicSendMsgBottomView()<UITextFieldDelegate>

@end
@implementation QLDynamicSendMsgBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLDynamicSendMsgBottomView viewFromXib];
        
        self.tf.borderStyle = UITextBorderStyleNone;
        self.tf.delegate = self;
        [self.tf addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
#pragma mark - action
//输入值变化
- (void)textFieldChange:(UITextField *)tf {
    self.sendBtn.selected = tf.text.length == 0?NO:YES;
    
}
//输入结束
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.sendBtn.selected = textField.text.length == 0?NO:YES;
    
}
@end
