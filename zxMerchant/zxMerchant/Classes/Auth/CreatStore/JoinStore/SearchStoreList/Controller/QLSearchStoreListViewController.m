//
//  QLSearchStoreListViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/4/22.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLSearchStoreListViewController.h"
#import "QLJoinStoreCell.h"
#import "QLApplyJoinStoreViewController.h"
#import "QLJoinStoreDetailViewController.h"

@interface QLSearchStoreListViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation QLSearchStoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavi];
    //tableView
    [self tableViewSet];
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self carListRequestWithWord:@""];
}

//车行列表
- (void)carListRequestWithWord:(NSString *)word {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"find_business",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"business_name":word} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        NSDictionary *dic = (NSDictionary *)response;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[[dic objectForKey:@"result_info"] objectForKey:@"business_list"]];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}


#pragma mark - action
//申请加入
- (void)applyBtnClick:(NSString *)bus_id {
    QLApplyJoinStoreViewController *ajsVC = [QLApplyJoinStoreViewController new];
    ajsVC.bussiness_id = bus_id;
    [self.navigationController pushViewController:ajsVC animated:YES];
}
//取消
- (void)rightItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
//设置导航栏
- (void)setNavi {
    //中间输入框
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-100, 30)];
    self.searchBar = [[QLBaseSearchBar alloc]initWithFrame:titleView.bounds];
    [self.searchBar setBjColor:[UIColor groupTableViewBackgroundColor]];
    self.searchBar.placeholder = @"输入搜索内容";
    self.searchBar.textField.clearButtonMode = UITextFieldViewModeNever;
    self.searchBar.delegate = self;
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
    //右按钮
    UIButton *rigthBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 30)];
    rigthBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rigthBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [rigthBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rigthBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rigthBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //去掉返回按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    leftItem.width = 10;
    self.navigationItem.leftBarButtonItems = @[leftItem];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self carListRequestWithWord:self.searchBar.text];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *strr = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    if(strr && strr.length > 0 && ![NSString isEmptyString:strr]) {
        return YES;
    } else {
        [self carListRequestWithWord:@""];
    }
    return YES;
}

#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 68, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLJoinStoreCell" bundle:nil] forCellReuseIdentifier:@"joinStoreCell"];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLJoinStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"joinStoreCell" forIndexPath:indexPath];
    NSDictionary *dataDic = [self.dataArray objectAtIndex:indexPath.row];
    cell.carName.text = [dataDic objectForKey:@"business_name"];
    cell.carAddress.text  = [dataDic objectForKey:@"address"];
    [cell.carImageV sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"business_pic"]]];
    
    [cell setSelectedBlock:^{
        [self applyBtnClick:[dataDic objectForKey:@"business_id"]];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //这边不给直接进
//    NSDictionary *dataDic = [self.dataArray objectAtIndex:indexPath.row];
//    QLJoinStoreDetailViewController *jsdVC = [[QLJoinStoreDetailViewController alloc] initWithDataDic:@{@"operation_type":@"application_information",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"business_id":[dataDic objectForKey:@"business_id"]}];
//    [self.navigationController pushViewController:jsdVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    UILabel *lb = [UILabel new];
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = [UIColor colorWithHexString:@"#999999"];
    lb.text = @"匹配店铺";
    [headerView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.mas_equalTo(18);
    }];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


@end
