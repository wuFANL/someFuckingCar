//
//  QLEditPermissionViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/23.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLEditPermissionViewController.h"
#import "QLSubmitBottomView.h"
#import "QLEditPermissionCell.h"

@interface QLEditPermissionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLSubmitBottomView *bottomView;
/** 商户角色列表*/
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation QLEditPermissionViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑权限";
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    //tableView
    [self tableViewSet];
    WEAKSELF
    [QLNetworkingManager postWithUrl:BusinessPath params:@{
        @"operation_type":@"role_list",
        @"business_id":[QLUserInfoModel getLocalInfo].business.business_id
    } success:^(id response) {
        NSDictionary *resDic = response;
        NSArray* listArray = [[resDic objectForKey:@"result_info"] objectForKey:@"role_list"];
        if ([listArray isKindOfClass:[NSArray class]] && listArray.count > 0) {
            weakSelf.dataArray = [listArray mutableCopy];
            [weakSelf.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
    
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLEditPermissionCell" bundle:nil] forCellReuseIdentifier:@"permissionCell"];
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
    QLEditPermissionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"permissionCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        NSDictionary* dataDic = self.dataArray[indexPath.row];
        cell.dataDic = dataDic;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)permissionBlock {
    NSDictionary *targetDic = [NSDictionary dictionary];
    NSInteger cellCount = [self.tableView numberOfRowsInSection:0];
    for (NSInteger i = 0; i< cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        QLEditPermissionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.selected) {
            targetDic = [self.dataArray objectAtIndex:i];
            if (self.block) {
                self.block(targetDic);
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;;
        }
    }
    
}

#pragma mark - Lazy
- (QLSubmitBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLSubmitBottomView new];
        [_bottomView.funBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_bottomView.funBtn addTarget:self action:@selector(permissionBlock) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
