//
//  QLCarManagerPageHeadView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarManagerPageHeadView.h"
@interface QLCarManagerPageHeadView()

@end
@implementation QLCarManagerPageHeadView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLCarManagerPageHeadView viewFromXib];
        
        //类型切换
        self.chooseView.column = 3;
        self.chooseView.typeArr = @[@"全部车源",@"我的车源",@"合作车源"];
        self.chooseView.lineColor = GreenColor;
        self.chooseView.lineWidth = 10;
        
        self.showResultView = NO;
    }
    return self;
}
#pragma mark - setter
- (void)setShowResultView:(BOOL)showResultView {
    _showResultView = showResultView;
    if (showResultView) {
        self.resultView.hidden = NO;
        self.resultViewHeight.constant = 48;
    } else {
        self.resultView.hidden = YES;
        self.resultViewHeight.constant = 0;
    }
}
@end
