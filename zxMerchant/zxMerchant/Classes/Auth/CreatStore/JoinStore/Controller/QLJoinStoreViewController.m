//
//  QLJoinStoreViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLJoinStoreViewController.h"
#import "QLJoinStoreCell.h"

@interface QLJoinStoreViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseSearchBar *searchBar;

@end

@implementation QLJoinStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavi];
    //tableView
    [self tableViewSet];
}

#pragma mark - action
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
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLJoinStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"joinStoreCell" forIndexPath:indexPath];
    
    return cell;
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
