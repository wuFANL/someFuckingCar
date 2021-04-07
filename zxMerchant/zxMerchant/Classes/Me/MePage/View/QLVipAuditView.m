//
//  QLVipAuditView.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/16.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLVipAuditView.h"

@interface QLVipAuditView()<QLBaseViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *czView;

@end
@implementation QLVipAuditView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLVipAuditView viewFromXib];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.viewDelegate = self;
        
        
        [self.czView addSubview:self.rView];
        [self.rView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.czView);
        }];
    }
    return self;
}
- (IBAction)closeBtnClick:(id)sender {
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
    [self hidden];
}

#pragma mark - Lazy
- (QLRechargeView *)rView {
    if (!_rView) {
        _rView = [QLRechargeView new];
    }
    return _rView;
}
@end
