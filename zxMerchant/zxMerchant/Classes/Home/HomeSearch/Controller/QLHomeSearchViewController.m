//
//  QLHomeSearchViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/8.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLHomeSearchViewController.h"
#import "QLSearchHistoryCell.h"
#import "QLHomeCarCell.h"
#import "QLCarSourceDetailViewController.h"

@interface QLHomeSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,QLBaseTableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) QLBaseSearchBar *searchBar;
@property (nonatomic, strong) QLBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *historyArr;
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation QLHomeSearchViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavi];
    //添加tableView
    [self.view addSubview:self.tableView];
    //布局
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //获取本地历史搜索数据
    self.historyArr = [NSMutableArray arrayWithArray:[UserDefaults objectForKey:LocalSearchHistoryKey]];
    
}
#pragma mark - network
- (void)dataRequest {
    if (self.searchType == SearchCar) {
        [self searchCarRequest];
    } else if (self.searchType == SearchBrand) {
        [self searchBrandRequest];
    }
}
- (void)searchCarRequest {
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"query_all_car_list",@"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id),@"search_content":self.searchBar.text,@"page_no":@(self.tableView.page),@"page_size":@(listShowCount)} success:^(id response) {
        if (self.tableView.page == 1) {
            [self.listArr removeAllObjects];
        }
        NSArray *temArr = response[@"result_info"][@"car_list"];
        [self.listArr addObjectsFromArray:temArr];
        
        if (self.listArr.count == 0) {
            self.tableView.hidden = YES;
            self.showNoDataView = YES;
        } else {
            self.tableView.hidden = NO;
            self.showNoDataView = NO;
        }
        
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
- (void)searchBrandRequest {
    [QLNetworkingManager postWithUrl:BasePath params:@{@"operation_type":@"get_series_by_brand",@"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id),@"brand_name":self.searchBar.text,@"page_no":@(self.tableView.page),@"page_size":@(listShowCount)} success:^(id response) {
        if (self.tableView.page == 1) {
            [self.listArr removeAllObjects];
        }
        NSArray *temArr = response[@"result_info"][@"series_list"];
        [self.listArr addObjectsFromArray:temArr];
        
        if (self.listArr.count == 0) {
            self.tableView.hidden = YES;
            self.showNoDataView = YES;
        } else {
            self.tableView.hidden = NO;
            self.showNoDataView = NO;
        }
        
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
#pragma mark - action
//搜索点击
- (void)searchItemClick {
    if (self.searchBar.text.length == 0) {
        return;
    } 
    [self.searchBar resignFirstResponder];
    if (self.searchBar.text.length != 0) {
        //本地保存历史搜索
        if (![self.historyArr containsObject:self.searchBar.text]) {
            [self.historyArr addObject:self.searchBar.text];
            [UserDefaults setObject:self.historyArr forKey:LocalSearchHistoryKey];
        }
    }
    
    self.tableView.showHeadRefreshControl = YES;
    self.tableView.showFootRefreshControl = YES;
}
//清空点击
- (void)deleteBtnClick {
    [self.historyArr removeAllObjects];
    [UserDefaults setObject:nil forKey:LocalSearchHistoryKey];
    [self.tableView reloadData];
}
#pragma mark -设置导航栏
- (void)setNavi {
    //中间输入框
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-110, 30)];
    QLBaseSearchBar *searchBar = [[QLBaseSearchBar alloc]initWithFrame:titleView.bounds];
    [searchBar setBjColor:[UIColor groupTableViewBackgroundColor]];
    searchBar.placeholder = @"输入搜索内容";
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    self.navigationItem.titleView = titleView;
    
    //右按钮
    UIButton *rigthBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rigthBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rigthBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [rigthBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rigthBtn addTarget:self action:@selector(searchItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rigthBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
//searchBar点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchItemClick];
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchBar.text.length == 0) {
        return 1;
    }
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchBar.text.length == 0) {
        QLSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLB.text = @"历史搜索";
            cell.deleteBtn.hidden = NO;
            cell.itemArr = self.historyArr;
            [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.result = ^(id result) {
            self.searchBar.text = result;
            [self searchItemClick];
        };
        return cell;
    } else {
        if (self.searchType == SearchCar) {
            QLHomeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hCarCell" forIndexPath:indexPath];
            if (self.listArr.count > indexPath.row) {
                [cell updateUIWithDic:self.listArr[indexPath.row]];
            }
            
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            NSDictionary *dic = self.listArr[indexPath.row];
            if (self.searchType == SearchBrand) {
                cell.textLabel.text = QLNONull(dic[@"series_name"]);
            }
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchType == SearchCar) {
        if (indexPath.row < self.listArr.count) {
            NSDictionary *dataInfo = self.listArr[indexPath.row];
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
    } else if (self.searchType == SearchBrand) {
        //发送通知
        NSDictionary *dic = self.listArr[indexPath.row];
        if(self.bsBlock)
        {
            self.bsBlock(dic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
#pragma mark -懒加载
- (QLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QLBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.extendDelegate = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
        [_tableView registerNib:[UINib nibWithNibName:@"QLSearchHistoryCell" bundle:nil] forCellReuseIdentifier:@"historyCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"QLHomeCarCell" bundle:nil] forCellReuseIdentifier:@"hCarCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        
    }
    return _tableView;
}
- (NSMutableArray *)historyArr {
    if (!_historyArr) {
        _historyArr = [NSMutableArray array];
    }
    return _historyArr;
}
- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}

@end
