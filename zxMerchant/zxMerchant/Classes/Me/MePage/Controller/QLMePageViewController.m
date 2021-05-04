//
//  QLMePageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/9/27.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLMePageViewController.h"
#import "QLMePageHeadView.h"
#import "QLVipAuditView.h"
#import "QLMyInfoPageViewController.h"
#import "QLStoreInvitationListViewController.h"
#import "QLMyBrowseViewController.h"
#import "QLMySubscriptionsPageViewController.h"
#import "QLHelpSellViewController.h"
#import "QLVipCenterViewController.h"
#import "QLStaffListViewController.h"
#import "QLSetUpViewController.h"


@interface QLMePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLMePageHeadView *headView;

@end

@implementation QLMePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)getInfo {
    // 请求数据
    NSDictionary *para = @{
        @"operation_type":@"all_info",
        @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
        @"business_id":[QLUserInfoModel getLocalInfo].business.business_id
    };
    WEAKSELF
    [QLNetworkingManager postWithUrl:UserPath params:para success:^(id response) {
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableView
    [self tableViewSet];
    // 请求具体信息
}
#pragma mark - 头部
//个人信息
- (void)myInfoClick {
    QLMyInfoPageViewController *mipVC = [QLMyInfoPageViewController new];
    [self.navigationController pushViewController:mipVC animated:YES];
}
//会员中心
- (void)vipStatusBtnClick {
    //    QLVipAuditView *vaView = [QLVipAuditView new];
    //    [vaView show];
    
    QLVipCenterViewController *vcVC = [QLVipCenterViewController new];
    [self.navigationController pushViewController:vcVC animated:YES];
}
//店铺邀请列表
- (void)storeInvitationBtnClick {
    QLStoreInvitationListViewController *silVC = [QLStoreInvitationListViewController new];
    [self.navigationController pushViewController:silVC animated:YES];
}
//头部功能按钮
- (void)headControlClick:(UIButton *)sender {
    if (sender == self.headView.aControl) {
        //我的浏览
        QLMyBrowseViewController *mbVC = [QLMyBrowseViewController new];
        [self.navigationController pushViewController:mbVC animated:YES];
    } else if (sender == self.headView.bControl) {
        //我的帮卖
        QLHelpSellViewController *hsVC = [QLHelpSellViewController new];
        [self.navigationController pushViewController:hsVC animated:YES];
    } else {
        //我的订阅
        QLMySubscriptionsPageViewController *mspVC = [QLMySubscriptionsPageViewController new];
        [self.navigationController pushViewController:mspVC animated:YES];
    }
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = WhiteColor;
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //tableHeaderView
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 300)];
    [tableHeaderView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableHeaderView);
    }];
    self.tableView.tableHeaderView = tableHeaderView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fun%ld",indexPath.row+1]];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#FF6600"];
    cell.detailTextLabel.text = @"";
    if (indexPath.row == 0) {
        cell.textLabel.text = @"店账户余额(元) ";
        cell.detailTextLabel.text = @"0.0";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"员工管理";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"专属客服";
    } else {
        cell.textLabel.text = @"系统设置";
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-3) {
        //员工管理
        QLStaffListViewController *slVC = [QLStaffListViewController new];
        [self.navigationController pushViewController:slVC animated:YES];
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-2) {
        //专属客服
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        //设置
        QLSetUpViewController *suVC = [QLSetUpViewController new];
        [self.navigationController pushViewController:suVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
    }];
}
#pragma mark - Lazy
- (QLMePageHeadView *)headView {
    if(!_headView) {
        _headView = [QLMePageHeadView new];
        [_headView.headBtn addTarget:self action:@selector(myInfoClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView.nikenameBtn addTarget:self action:@selector(myInfoClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView.numBtn addTarget:self action:@selector(myInfoClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView.storeNameBtn addTarget:self action:@selector(myInfoClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView.storeInvitationBtn addTarget:self action:@selector(storeInvitationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView.vipStatusBtn addTarget:self action:@selector(vipStatusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView.aControl addTarget:self action:@selector(headControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView.bControl addTarget:self action:@selector(headControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView.cControl addTarget:self action:@selector(headControlClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _headView;
}
@end
