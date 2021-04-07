//
//  QLUnbindStoreView.m
//  zxMerchant
//
//  Created by lei qiao on 2021/1/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLUnbindStoreView.h"
@interface QLUnbindStoreView()<QLBaseViewDelegate>

@end
@implementation QLUnbindStoreView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLUnbindStoreView viewFromXib];
        self.viewDelegate = self;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        [self.alertView roundRectCornerRadius:4 borderWidth:1 borderColor:ClearColor];
        [self.tfView roundRectCornerRadius:2 borderWidth:1 borderColor:LightGrayColor];
        self.tf.borderStyle = UITextBorderStyleNone;
        
    }
    return self;
}

- (IBAction)cancelBtnClick:(id)sender {
    [self hidden];
}
- (void)show {
    self.frame = [UIScreen mainScreen].bounds;
    [KeyWindow addSubview:self];
    
}
- (void)hidden {
    [self removeFromSuperview];
}
- (void)hiddenViewEvent {
    
}
@end
