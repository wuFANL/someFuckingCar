//
//  QLCarCircleAccMoreView.m
//  zxMerchant
//
//  Created by lei qiao on 2021/5/19.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLCarCircleAccMoreView.h"

@implementation QLCarCircleAccMoreView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLCarCircleAccMoreView viewFromXib];
        
       
    }
    return self;
}
- (IBAction)closeBtnClick:(id)sender {
    [self hidden];
}
- (void)hidden {
    CGFloat width = self.width;
    self.frame = CGRectMake(self.origin.x+width, self.origin.y, 0, self.size.height);
    [UIView animateWithDuration:animationDuration animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
