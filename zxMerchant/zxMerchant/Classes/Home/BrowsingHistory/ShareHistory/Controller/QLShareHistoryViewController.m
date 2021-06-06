//
//  QLShareHistoryViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/30.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLShareHistoryViewController.h"
#import "QLShareHistoryHeadView.h"
#import "QLShareHistoryCell.h"
#import "QLBrowseDetailViewController.h"
#import "QLShareHistoryModel.h"
@interface QLShareHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) QLShareHistoryHeadView *headView;
@property (nonatomic, strong) QLBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation QLShareHistoryViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"分享记录";
    //tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
#pragma mark- network
//分享信息
- (void)getHistoryInfo {
    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_share_data",@"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id)} success:^(id response) {
        NSDictionary *param = response[@"result_info"];
        self.headView.totalNumLB.text = [NSString stringWithFormat:@"%ld",(long)[param[@"share_all"] integerValue]];
        self.headView.visitorsNumLB.text = [NSString stringWithFormat:@"%ld",(long)[param[@"visit_today"] integerValue]];
        self.headView.todayNumLB.text = [NSString stringWithFormat:@"%ld",(long)[param[@"share_today"] integerValue]];
    } fail:^(NSError *error) {
        
    }];
}
//分享列表
- (void)getShareList {
    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_share_list",@"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id),@"page_no":@(self.tableView.page),@"page_size":@(listShowCount)} success:^(id response) {
        NSArray *temArr = [NSArray yy_modelArrayWithClass:[QLShareHistoryModel class] json:response[@"result_info"][@"log_list"]];
        if (self.tableView.page == 1) {
            [self.listArr removeAllObjects];
        }
        [self.listArr addObjectsFromArray:temArr];
        //刷新设置
        [self.tableView.mj_header endRefreshing];
        if (temArr.count == listShowCount) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark- action
//分页
- (void)dataRequest {
    if (self.tableView.page == 1) {
        [self getHistoryInfo];
    }
    [self getShareList];
}
//查看详情
- (void)detailBtnClick {
    QLBrowseDetailViewController *bdVC= [QLBrowseDetailViewController new];
    bdVC.log_type = @"1001";
    bdVC.about_id = QLNONull([QLUserInfoModel getLocalInfo].account.account_id);
    [self.navigationController pushViewController:bdVC animated:YES];
    
}
//查看浏览详情
- (void)browseBtnClick:(UIButton *)sender {
    QLShareHistoryModel *model = self.listArr[sender.tag];
    QLBrowseDetailViewController *bdVC= [QLBrowseDetailViewController new];
    bdVC.log_type = @"1002";
    bdVC.about_id = model.about_id;
    bdVC.infoModel = model;
    [self.navigationController pushViewController:bdVC animated:YES];
}
#pragma mark- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLShareHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    cell.browseBtn.tag = indexPath.row;
    [cell.browseBtn addTarget:self action:@selector(browseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.model = self.listArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 105;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}
#pragma mark- lazyLoading
- (QLShareHistoryHeadView *)headView {
    if (!_headView) {
        _headView = [QLShareHistoryHeadView new];
        [_headView.detailBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}
- (QLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerNib:[UINib nibWithNibName:@"QLShareHistoryCell" bundle:nil] forCellReuseIdentifier:@"historyCell"];
        _tableView.delegate = self;
        _tableView.dataSource= self;
        _tableView.extendDelegate = self;
        _tableView.showHeadRefreshControl = YES;
        _tableView.showFootRefreshControl = YES;
        
        //tableHeaderView
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 155)];
        [headerView addSubview:self.headView];
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(headerView);
        }];
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}
- (NSMutableArray *)listArr {
    if(!_listArr) {
        _listArr = [NSMutableArray new];
    }
    return _listArr;
}

@end
