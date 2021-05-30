//
//  QLMySubscriptionsPageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/27.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLMySubscriptionsPageViewController.h"
#import "QLNoSubscriptionsView.h"
#import "QLSubListTitleCell.h"
#import "QLHomeCarCell.h"
#import "QLSubListMoreCell.h"
#import "QLMySubscriptionsDetailViewController.h"
#import "QLAdvancedScreeningViewController.h"

@interface QLMySubscriptionsPageViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation QLMySubscriptionsPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self dataRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //设置导航
    [self setNavi];
    //背景
    self.showBackgroundView = NO;
    QLNoSubscriptionsView *subView = [QLNoSubscriptionsView new];
    [self.backgroundView addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView);
    }];
    
    //tableView
    [self tableViewSet];
}

- (void)dataRequest {
    NSDictionary *para = @{
        Operation_type:@"subscribe_list",
        @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
        @"page_no":@(self.tableView.page),
        @"page_size":@(20)
    };
    
    WEAKSELF
    [QLNetworkingManager postWithUrl:BusinessPath params:para success:^(id response) {
        NSLog(@"%@",response);
        NSDictionary *data = [response objectForKey:@"result_info"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSArray *dataArr = [data objectForKey:@"subscribe_list"];
            if ([dataArr isKindOfClass:[NSArray class]]) {
                if (weakSelf.tableView.page == 1) {
                    // 头部刷新
                    weakSelf.listArr = [dataArr mutableCopy];
                } else {
                    // 新增数据
                    [weakSelf.listArr addObjectsFromArray:dataArr];
                }
            }
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - navigation
//添加订阅
- (void)addSubClick {
    //筛选
    QLAdvancedScreeningViewController *asVC = [QLAdvancedScreeningViewController new];
    asVC.showCity = NO;
    asVC.isSubscription = YES;
    [self.navigationController pushViewController:asVC animated:YES];
}
//设置导航
- (void)setNavi {
    self.navigationItem.title = @"我的订阅";
    //右导航按钮
    UIButton *rightBtn = [UIButton new];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [rightBtn setTitle:@"添加订阅" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addSubClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSubListTitleCell" bundle:nil] forCellReuseIdentifier:@"subListTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLHomeCarCell" bundle:nil] forCellReuseIdentifier:@"hCarCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSubListMoreCell" bundle:nil] forCellReuseIdentifier:@"subListMoreCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.extendDelegate = self;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
    [self.tableView setShowHeadRefreshControl:YES];
    [self.tableView setShowFootRefreshControl:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSDictionary *dataDic = self.listArr[section];
    NSArray *tempArr = [dataDic objectForKey:@"car_list"];
    if ([tempArr isKindOfClass:[NSArray class]]) {
        return 2 + (tempArr.count > 3?3:tempArr.count);
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.listArr[indexPath.section];
    if (indexPath.row == 0) {
        // 标题 标签
        QLSubListTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subListTitleCell" forIndexPath:indexPath];
        [cell updateWith:dataDic];
        return cell;
    } else if (indexPath.row == ([tableView numberOfRowsInSection:indexPath.section]-1)) {
        // 时间
        QLSubListMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subListMoreCell" forIndexPath:indexPath];
        [cell updateWithDic:dataDic];
        return cell;
    } else {
        QLHomeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hCarCell" forIndexPath:indexPath];
        cell.lineView.hidden = NO;
        
        NSArray *tempArr = [dataDic objectForKey:@"car_list"];
        if ([tempArr isKindOfClass:[NSArray class]]) {
            [cell updateUIWithDic:tempArr[indexPath.row]];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击
    QLMySubscriptionsDetailViewController *msdVC = [QLMySubscriptionsDetailViewController new];
    // 展示详情
    [msdVC updateWithDic:self.listArr[indexPath.section]];
    [self.navigationController pushViewController:msdVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = 2;
    NSDictionary *dataDic = self.listArr[indexPath.section];
    NSArray *tempArr = [dataDic objectForKey:@"car_list"];
    if ([tempArr isKindOfClass:[NSArray class]]) {
        count = 2 + (tempArr.count > 3?3:tempArr.count);
    }
    if (indexPath.row == 0) {
        // 标题
        return 90;
    } else if (indexPath.row == (count-1)) {
        // 时间
        return 48;
    } else {
        // 车
        return 120;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [QLToolsManager cellSetRound:tableView Cell:cell IndexPath:indexPath SideSpace:0];
}
#pragma mark - Lazy
- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}
@end
