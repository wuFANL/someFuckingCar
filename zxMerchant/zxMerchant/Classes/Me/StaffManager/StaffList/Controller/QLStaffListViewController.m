//
//  QLStaffListViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/21.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLStaffListViewController.h"
#import "QLSubmitBottomView.h"
#import "QLStoreInvitationListCell.h"
#import "QLAddStaffViewController.h"
#import "QLStaffDetailViewController.h"


@interface QLStaffListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLSubmitBottomView *bottomView;

/** 员工数据*/
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation QLStaffListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"员工管理";
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    //tableView
    [self tableViewSet];
    
    [self sendRequest];
}

- (void)sendRequest{
    NSDictionary * para = @{
        @"operation_type":@"personnel_list",
        @"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id
    };
    WEAKSELF
    [QLNetworkingManager postWithUrl:BusinessPath params:para success:^(id response) {
        NSArray *dataArr = [[response objectForKey:@"result_info"] objectForKey:@"at_work_personnel_list"];
        if ([dataArr isKindOfClass:[NSArray class]]) {
            weakSelf.dataArray = [dataArr mutableCopy];
            [weakSelf.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

#pragma mark - action
- (void)funBtnClick {
    QLAddStaffViewController *asVC = [QLAddStaffViewController new];
    asVC.isAddStaff = YES;
    [self.navigationController pushViewController:asVC animated:YES];
}

#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLStoreInvitationListCell" bundle:nil] forCellReuseIdentifier:@"storeInvitationListCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLStoreInvitationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeInvitationListCell" forIndexPath:indexPath];
    [cell updateWithData:self.dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QLStaffDetailViewController *sdVC = [QLStaffDetailViewController new];
    sdVC.status = indexPath.row>4?4:(indexPath.row+1);
    [self.navigationController pushViewController:sdVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - Lazy
- (QLSubmitBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLSubmitBottomView new];
        [_bottomView.funBtn setTitle:@"新建账号" forState:UIControlStateNormal];
        [_bottomView.funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
@end
