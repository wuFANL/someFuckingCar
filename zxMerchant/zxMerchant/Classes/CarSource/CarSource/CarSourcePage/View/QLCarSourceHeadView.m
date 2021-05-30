//
//  QLCarSourceHeadView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/17.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarSourceHeadView.h"

@implementation QLCarSourceHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLCarSourceHeadView viewFromXib];
        
        [self.bannerBjView addSubview:self.bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bannerBjView);
        }];
        
        self.typeView.backgroundColor = ClearColor;
        self.typeView.column = 2;
        self.typeView.lineColor = [UIColor colorWithHexString:@"#FACD89"];
        self.typeView.lineWidth = 12;
        
        self.showResultView = NO;
    }
    return self;
}

#pragma mark - setter
- (void)setShowResultView:(BOOL)showResultView {
    _showResultView = showResultView;
    if (showResultView) {
        self.conditionResultView.hidden = NO;
        self.conditionResultViewHeight.constant = 48;
    } else {
        self.conditionResultView.hidden = YES;
        self.conditionResultViewHeight.constant = 0;
    }
}
#pragma mark - Lazy
- (QLBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [QLBannerView new];
        _bannerView.havePage = NO;
    }
    return _bannerView;
}
@end
