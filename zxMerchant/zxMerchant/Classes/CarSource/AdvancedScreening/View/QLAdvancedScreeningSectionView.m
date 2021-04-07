//
//  QLAdvancedScreeningSectionView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLAdvancedScreeningSectionView.h"
@interface QLAdvancedScreeningSectionView()
@property (nonatomic, weak) UIButton *currentBtn;

@end
@implementation QLAdvancedScreeningSectionView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLAdvancedScreeningSectionView viewFromXib];
        
        self.showFunBtn = NO;
    }
    return self;
}
#pragma mark - setter
- (void)setShowFunBtn:(BOOL)showFunBtn {
    _showFunBtn = showFunBtn;
    if (showFunBtn) {
        self.aBtn.hidden = NO;
        self.bBtn.hidden = NO;
    } else {
        self.aBtn.hidden = YES;
        self.bBtn.hidden = YES;
    }
}
#pragma mark - action
- (IBAction)funBtnClick:(UIButton *)sender {
    if (self.currentBtn != sender) {
        sender.selected = YES;
        self.currentBtn.selected = NO;
        self.currentBtn = sender;
        
    }
    
}
@end
