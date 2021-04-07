//
//  QLVipCenterViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/1/10.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLVipCenterViewController.h"
#import "QLVipCenterHeadView.h"
#import "QLVipPriceListView.h"
#import "QLRechargeView.h"
#import "QLSubmitSuccessViewController.h"

@interface QLVipCenterViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) QLVipCenterHeadView *headView;
@property (nonatomic, strong) QLVipPriceListView *priceView;
@property (nonatomic, strong) QLRechargeView *rView;

@end

@implementation QLVipCenterViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor darkTextColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor groupTableViewBackgroundColor]]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员中心";
    
    CGFloat topOffsetY = 48+(BottomOffset?44:20);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(-topOffsetY);
    }];
    
    [self.scrollView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    self.priceView.collectionView.dataArr = [@[@"1",@"2",@"3"] mutableCopy];
    [self.scrollView addSubview:self.priceView];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom);
        make.height.mas_equalTo(200);
    }];
    
    [self.scrollView addSubview:self.rView];
    [self.rView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.top.equalTo(self.priceView.mas_bottom);
        make.height.mas_equalTo(85);
        
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"privilegeBj"]];
    [self.scrollView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(18);
        make.right.equalTo(self.view).offset(-18);
        make.top.equalTo(self.rView.mas_bottom);
        make.height.mas_equalTo(346);
    }];
    
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    CGFloat topOffsetY = 48+(BottomOffset?44:20);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, topOffsetY+831);
}
//立即充值
- (void)rechargeBtnClick {
    QLSubmitSuccessViewController *ssVC = [QLSubmitSuccessViewController new];
    [self.navigationController pushViewController:ssVC animated:YES];
}
#pragma mark - Lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (QLVipCenterHeadView *)headView {
    if (!_headView) {
        _headView = [QLVipCenterHeadView new];
       
    }
    return _headView;
}
- (QLVipPriceListView *)priceView {
    if (!_priceView) {
        _priceView = [QLVipPriceListView new];
       
    }
    return _priceView;
}
- (QLRechargeView *)rView {
    if (!_rView) {
        _rView = [QLRechargeView new];
        _rView.backgroundColor = ClearColor;
        [_rView.czBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rView;
}

@end
