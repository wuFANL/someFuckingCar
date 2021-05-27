//
//  QLMyCarDetailBottomView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/10.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLMyCarDetailBottomView.h"

@implementation QLMyCarDetailBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLMyCarDetailBottomView viewFromXib];
        self.height = 75;
        
        self.openControlLeft.constant = ScreenWidth*(97/375.0);
        
        self.placeholderView.hidden = YES;
        self.placeholderViewHeight.constant = 35;
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
- (IBAction)openControlClick:(id)sender {
    self.placeholderView.hidden = NO;
    self.placeholderViewHeight.constant = 95;
    self.height = 135;
}
- (IBAction)closeBtnClick:(id)sender {
    self.placeholderView.hidden = YES;
    self.placeholderViewHeight.constant = 35;
    self.height = 75;
}

-(void)defaultOpen
{
    [self openControlClick:nil];
}
@end
