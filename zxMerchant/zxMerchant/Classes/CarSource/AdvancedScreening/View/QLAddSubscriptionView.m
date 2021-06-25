//
//  QLAddSubscriptionView.m
//  zxMerchant
//
//  Created by lei qiao on 2021/3/1.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLAddSubscriptionView.h"
@interface QLAddSubscriptionView()<QLBaseViewDelegate>

@end
@implementation QLAddSubscriptionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLAddSubscriptionView viewFromXib];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.viewDelegate = self;
        
        self.textTF.borderStyle = UITextBorderStyleNone;
        
    }
    return self;
}

- (void)show {
    self.textTF.text = @"";
    [self.textTF becomeFirstResponder];
    [KeyWindow addSubview:self];
}

- (void)hidden {
    [self removeFromSuperview];
}

- (void)hiddenViewEvent {
    [self hidden];
}
@end
