//
//  QLSearchAddressBookViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/10.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLSearchAddressBookViewController.h"
#import "QLSearchHistoryCell.h"

@interface QLSearchAddressBookViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) QLBaseSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *hotArr;
@property (nonatomic, strong) NSArray *listArr;
@end

@implementation QLSearchAddressBookViewController
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
    //tableView
    [self tableViewSet];
    
}
#pragma mark - action
//取消
- (void)rightItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
//searchBar点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.searchBar.text.length == 0) {
        return;
    }
    [self.searchBar resignFirstResponder];
    //搜索
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.tableView.backgroundColor = self.searchBar.text.length==0?WhiteColor:[UIColor groupTableViewBackgroundColor];
    [self.tableView reloadData];
}
- (void)setNavi {
    //中间输入框
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-100, 30)];
    QLBaseSearchBar *searchBar = [[QLBaseSearchBar alloc]initWithFrame:titleView.bounds];
    [searchBar setBjColor:[UIColor groupTableViewBackgroundColor]];
    searchBar.placeholder = @"输入搜索内容";
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
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
    self.tableView.backgroundColor = self.searchBar.text.length==0?WhiteColor:[UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSearchHistoryCell" bundle:nil] forCellReuseIdentifier:@"historyCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchBar.text.length == 0) {
        return 1;
    } else {
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchBar.text.length == 0?1:5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchBar.text.length == 0) {
        QLSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
        cell.titleLB.text = @"搜索指定内容";
        cell.deleteBtn.hidden = YES;
        cell.itemArr = @[@"分类名称",@"分类名称",@"分类名称"];
        cell.result = ^(id result) {
            self.searchBar.text = result;
            //搜索
            [self searchBarSearchButtonClicked:self.searchBar];
        };
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = @"车友昵称";
        return cell;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.searchBar.text.length != 0) {
        UIView *headerView = [UIView new];
        UILabel *lb = [UILabel new];
        lb.font = [UIFont systemFontOfSize:12];
        lb.textColor = [UIColor colorWithHexString:@"#666666"];
        lb.text = @"通讯";
        [headerView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.mas_equalTo(18);
        }];
        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.searchBar.text.length == 0?5:30;
}
#pragma mark - Lazy
- (NSMutableArray *)hotArr {
    if (!_hotArr) {
        _hotArr = [NSMutableArray array];
    }
    return _hotArr;
}
- (NSArray *)listArr {
    if (!_listArr) {
        _listArr = [NSArray array];
    }
    return _listArr;
}



@end
