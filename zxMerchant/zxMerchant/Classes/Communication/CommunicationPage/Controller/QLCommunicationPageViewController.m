//
//  QLCommunicationPageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/4.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCommunicationPageViewController.h"
#import "QLAddressBookListHeadView.h"
#import "QLMessagePageViewController.h"
#import "QLContactsPageViewController.h"
#import "QLSearchContactsViewController.h"
#import "QLSearchAddressBookViewController.h"
#import "QLNewFriendViewController.h"
#import "QLCarCircleViewController.h"

@interface QLCommunicationPageViewController ()<QLBaseSubViewControllerDelegate,QLAddressBookListHeadViewDelegate>
@property (nonatomic, strong) QLAddressBookListHeadView *headView;

@property (nonatomic, assign) BOOL isGotoQLCarCircleViewController;
@end

@implementation QLCommunicationPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (self.isGotoQLCarCircleViewController) {
        QLMessagePageViewController *ctl = (QLMessagePageViewController *)[self.subVCArr firstObject];
        [ctl carCricleBackToReload];
        self.isGotoQLCarCircleViewController = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //headView
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(150+(BottomOffset?44:20));
    }];
    //subView
    QLMessagePageViewController *mpVC = [QLMessagePageViewController new];
    [mpVC setMsgBlock:^(NSDictionary * _Nonnull messageDic) {
        NSString *headerPath = [messageDic objectForKey:@"head"];
        if (headerPath.length != 0) {
            self.headView.accBtn.hidden = NO;
            [self.headView.accBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:headerPath] forState:UIControlStateNormal];
            self.headView.accBtn.badgeValue = [messageDic objectForKey:@"badge"];
        } else {
            self.headView.accBtn.hidden = YES;
        }
        
    }];
    
    QLContactsPageViewController *cpVC = [QLContactsPageViewController new];
    [cpVC setHeaderBlock:^(NSString * _Nonnull headerPath) {
        if (headerPath.length != 0) {
            self.headView.accBtn.hidden = NO;
            [self.headView.accBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:headerPath] forState:UIControlStateNormal];
        } else {
            self.headView.accBtn.hidden = YES;
        }
        
    }];
    self.subVCArr = @[mpVC,cpVC];
    self.needGestureRecognizer = YES;
    self.delegate = self;
}
- (void)viewDidLayoutSubviews {
    for (UIViewController *vc in self.childViewControllers) {
        vc.view.frame = CGRectMake(0,CGRectGetMaxY(self.headView.frame), self.view.width, self.view.height-CGRectGetMaxY(self.headView.frame));
    }
}
#pragma mark - action
//搜索栏点击
- (void)searchBarClick {
    QLSearchAddressBookViewController *sabVC = [QLSearchAddressBookViewController new];
    [self.navigationController pushViewController:sabVC animated:YES];
}
//section模块点击
- (void)sectionClick {
    if (self.headView.chooseView.selectedIndex == 0) {
        //车友圈
        self.isGotoQLCarCircleViewController = YES;
        QLCarCircleViewController *ccVC = [QLCarCircleViewController new];
        [self.navigationController pushViewController:ccVC animated:YES];
        
    } else {
        //新的好友
        QLNewFriendViewController *nfVC = [QLNewFriendViewController new];
        [self.navigationController pushViewController:nfVC animated:YES];
    }
}
//头部加号点击
- (void)headAddClick {
    QLSearchContactsViewController *scVC = [QLSearchContactsViewController new];
    [self.navigationController pushViewController:scVC animated:YES];
}
//头部选择点击
- (void)chooseSelectIndex:(NSInteger)index {
    self.headView.sectionImgView.image = [UIImage imageNamed:index==0?@"carCircleIcon":@"newFriendIcon"];
    self.headView.titleLB.text = index==0?@"车友圈":@"新的车友";
    [self viewChangeAnimation:index];
}
//滑动切换
- (void)subViewChange:(UIViewController *)currentVC IndexPath:(NSInteger)index {
    self.headView.chooseView.selectedIndex = index;
}
#pragma mark - Lazy
- (QLAddressBookListHeadView *)headView {
    if(!_headView) {
        _headView = [QLAddressBookListHeadView new];
        _headView.delegate = self;
        [_headView.addBtn addTarget:self action:@selector(headAddClick) forControlEvents:UIControlEventTouchUpInside];
        _headView.accBtn.badgeValue = @"1";
    }
    return _headView;
}

@end
