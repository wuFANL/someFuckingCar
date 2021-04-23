//
//  QLBaseViewController.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/9/26.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBaseViewController.h"
#import <IQKeyboardManager.h>
@interface QLBaseViewController ()<QLBackgroundViewDelegate>

@end

@implementation QLBaseViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 默认开启键盘管理
    if([self keyboardManagerEnabled]) {
        [IQKeyboardManager sharedManager].enable = YES;
        // 控制点击背景是否收起键盘
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
        // 控制键盘上的工具条文字颜色是否用户自定义
        [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 44;
        // 控制是否显示键盘上的工具条
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    } else {
        [IQKeyboardManager sharedManager].enable = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //解决偏移问题
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //添加背景
    [self.view insertSubview:self.backgroundView atIndex:0];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.backgroundView.frame = self.view.bounds;
}
#pragma mark-  设置背景
//是否显示
- (void)setShowBackgroundView:(BOOL)showBackgroundView {
    if (showBackgroundView == YES) {
        self.backgroundView.hidden = NO;
    } else {
        self.backgroundView.hidden = YES;
    }
}
//设置背景文字
- (void)setBackgroundViewTitle:(NSString *)backgroundViewTitle {
    self.backgroundView.placeholder = backgroundViewTitle;
}
//点击事件
- (void)clickPlaceholderBtn:(UIButton *)sender {
    if ([self.baseDelegate respondsToSelector:@selector(centerBtnClick:)]) {
        [self.baseDelegate centerBtnClick:sender];
    }
}
//显示加载中页面
- (void)setShowLoadView:(BOOL)showLoadView {
    _showLoadView = showLoadView;
    if (showLoadView) {
        self.backgroundView.hidden = NO;
        self.backgroundViewTitle = @"加载中，请耐心等待...";
    } else {
        self.backgroundView.hidden = YES;
    }
}
//显示无数据页面
- (void)setShowNoDataView:(BOOL)showNoDataView {
    _showNoDataView = showNoDataView;
    if (showNoDataView) {
        self.backgroundView.hidden = NO;
        self.backgroundViewTitle = @"暂无数据哦~";
    } else {
        self.backgroundView.hidden = YES;
    }
}
//显示加载失败页面
- (void)setShowLoadErrorView:(BOOL)showLoadErrorView {
    _showLoadErrorView = showLoadErrorView;
    if (showLoadErrorView) {
        self.backgroundView.hidden = NO;
        self.backgroundViewTitle = @"加载失败，请重新加载";
    } else {
        self.backgroundView.hidden = YES;
    }
}

#pragma mark-  获取上个页面
- (UIViewController *)getLastVCByNaviBar {
    UIViewController *lastVC = nil;
    NSArray *vcs = self.navigationController.viewControllers;
    if (vcs.count != 0) {
        NSInteger index = [vcs indexOfObject:self];
        NSInteger lastIndex = index-1;
        lastVC = lastIndex<vcs.count&&lastIndex>0?vcs[lastIndex]:nil;
    }
    return lastVC;
}

#pragma mark-  是否启用键盘管理
- (BOOL)keyboardManagerEnabled {
    
    return YES;
};

#pragma mark - Lazy
- (QLBaseBackgroundView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[QLBaseBackgroundView alloc]init];
        _backgroundView.delegate= self;
    }
    return _backgroundView;
}

#pragma mark- system
- (void)dealloc {
    //收回键盘
    [self.view endEditing:YES];
}

// MARK: 通用方法
/* 结束编辑模式 */
- (void)endEidt {
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
/* 点击空白处收起键盘 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEidt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark-  Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
