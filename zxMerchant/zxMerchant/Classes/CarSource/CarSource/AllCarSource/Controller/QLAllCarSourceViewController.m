//
//  QLAllCarSourceViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/24.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLAllCarSourceViewController.h"
#import "QLHomeCarCell.h"
#import "QLCarSourceDetailViewController.h"

@interface QLAllCarSourceViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLAllCarSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableView
    [self tableViewSet];
}

- (void)endRefresh {
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}


#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.page = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLHomeCarCell" bundle:nil] forCellReuseIdentifier:@"hCarCell"];
    MJWeakSelf
    
    
    MJRefreshHeader* header =[MJDIYHeader headerWithRefreshingBlock:^{
        weakSelf.tableView.page = 0;
        [weakSelf.tableView.mj_header beginRefreshing];
        if (weakSelf.refreshBlock) {
            weakSelf.tableView.page = 0;
            [weakSelf.dataArray removeAllObjects];
            weakSelf.refreshBlock(0);
        }
    }];
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_footer beginRefreshing];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLHomeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hCarCell" forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.row) {
        [cell updateUIWithDic:self.dataArray[indexPath.row]];
    }
    
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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
