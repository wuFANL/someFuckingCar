//
//  QLUnreadMsgListViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLUnreadMsgListViewController.h"
#import "QLUnreadMsgListCell.h"
#import "QLRidersDynamicDetailViewController.h"
#import "QLUnreadMsgModel.h"

@interface QLUnreadMsgListViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) NSMutableArray *listArr;

@end

@implementation QLUnreadMsgListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tableView.showHeadRefreshControl = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //tableView
    [self tableViewSet];
}
#pragma mark - network
//列表数据
- (void)dataRequest {
    [QLNetworkingManager postWithUrl:DynamicPath params:@{} success:^(id response) {
        if (self.tableView.page == 1) {
            [self.listArr removeAllObjects];
        }
        QLUnreadMsgModel *model = [QLUnreadMsgModel yy_modelWithJSON:response[@"result_inf"][@"to_read_list"]];
        [self.listArr addObjectsFromArray:model.dynamic_response];
        if (self.listArr.count == 0) {
            self.tableView.hidden = YES;
            self.showNoDataView = YES;
        } else {
            self.tableView.hidden = NO;
            self.showNoDataView = NO;
        }
        [self.tableView.mj_header endRefreshing];
        if (model.dynamic_response.count == listShowCount) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //刷新
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:error.domain];
    }];
}
//清空
- (void)deleteRequest {
    
}
#pragma mark - action
//更多消息
- (void)moreBtnClick {
    self.tableView.showFootRefreshControl = YES;
}
//清空
- (void)rightItemClick {
    if (self.listArr.count != 0) {
        [self deleteRequest];
    }
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 72, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.extendDelegate = self;
    self.tableView.showFootRefreshControl = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLUnreadMsgListCell" bundle:nil] forCellReuseIdentifier:@"unreadMsgListCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLUnreadMsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unreadMsgListCell" forIndexPath:indexPath];
    QLDynamicMsgModel *model = self.listArr[indexPath.row];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.account_head_pic]];
    [cell.accImgView sd_setImageWithURL:[NSURL URLWithString:model.dynamic_first_pic]];
    cell.nameLB.text = model.account_nickname;
    cell.contentLB.text = model.content;
    cell.timeLB.text = @"";

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QLRidersDynamicDetailViewController *rddVC = [QLRidersDynamicDetailViewController new];
    [self.navigationController pushViewController:rddVC animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    
    QLBaseButton *moreBtn = [QLBaseButton new];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [moreBtn setTitle:@"查看更早的消息..." forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(footerView);
        make.height.mas_equalTo(20);
    }];
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}
#pragma mark - Lazy
- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}
@end
