//
//  QLMyBrowseViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/16.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLMyBrowseViewController.h"
#import "QLHomeCarCell.h"
#import "QLCarSourceDetailViewController.h"

@interface QLMyBrowseViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
/** 数据*/
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation QLMyBrowseViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USERCENTERREFRESH" object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.navigationItem.title = @"我的浏览";
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 18)];
    [clearBtn layoutButtonWithEdgeInsetsStyle:QLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [clearBtn setImage:[UIImage imageNamed:@"delete_green"] forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [clearBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    //tableView
    [self tableViewSet];
    
    [self dataRequest];
    
}
#pragma mark - 导航
//清空
- (void)clearBtnClick {
    WEAKSELF
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否确认删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 确认删除
        [QLNetworkingManager postWithUrl:UserPath params:@{
            @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
            @"operation_type":@"empty_visit_car"
        } success:^(id response) {
            [MBProgressHUD showSuccess:@"删除成功"];
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.tableView reloadData];
        } fail:^(NSError *error) {
            [MBProgressHUD showError:error.domain];
        }];
    }];
    
    [alert addAction:action];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dataRequest {
    WEAKSELF
    [QLNetworkingManager postWithUrl:UserPath params:@{
        @"operation_type":@"visit_car_list",
        @"account_id": [QLUserInfoModel getLocalInfo].account.account_id,
        @"page_no":@(self.tableView.page),
        @"page_size":@(self.tableView.previewCellCount)
    } success:^(id response) {
        // 取出数据数组
        NSArray *data = [[response objectForKey:@"result_info"] objectForKey:@"car_list"];
        if ([data isKindOfClass:[NSArray class]]) {
            // 是否是刷新的
            if (weakSelf.tableView.page > 1) {
                // 新增的数据
                [weakSelf.dataArray addObjectsFromArray:data];
            } else {
                weakSelf.dataArray = [data mutableCopy];
            }
        }
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.extendDelegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLHomeCarCell" bundle:nil] forCellReuseIdentifier:@"hCarCell"];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLHomeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hCarCell" forIndexPath:indexPath];
    [cell updateUIWithDic:self.dataArray[indexPath.row]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.dataArray.count) {
        NSDictionary *dataInfo = self.dataArray[indexPath.row];
        NSDictionary *carInfoData = @{
            //    account_id    对方用户id
            @"account_id":[dataInfo objectForKey:@"belonger"]?[dataInfo objectForKey:@"belonger"]:@"",
            //    car_id        车辆id model_id
            @"car_id":[dataInfo objectForKey:@"id"]?[dataInfo objectForKey:@"id"]:@""
        };
        QLCarSourceDetailViewController *csdVC = [QLCarSourceDetailViewController new];
        [csdVC updateVcWithData:carInfoData];
        [self.navigationController pushViewController:csdVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除浏览记录
        WEAKSELF
        NSDictionary *carInfo = self.dataArray[indexPath.row];
        [QLNetworkingManager postWithUrl:UserPath params:@{
            @"operation_type":@"remove_visit_car",
            @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
            @"log_id":EncodeStringFromDic(carInfo, @"log_id")
        } success:^(id response) {
            [MBProgressHUD showSuccess:@"删除成功"];
            [weakSelf dataRequest];
        } fail:^(NSError *error) {
            [MBProgressHUD showError:error.domain];
        }];
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark -- lazy
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
