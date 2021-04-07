//
//  QLNewFriendViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/12.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLNewFriendViewController.h"
#import "QLSearchContactsViewController.h"
#import "QLSearchAddressBookViewController.h"
#import "QLNewFriendCell.h"

@interface QLNewFriendViewController ()<QLBaseSearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseSearchBar *searchBar;

@end

@implementation QLNewFriendViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self naviSet];
    //tableView
    [self tableViewSet];
}
#pragma mark - 导航栏
- (void)noEditClick {
    QLSearchAddressBookViewController *sabVC = [QLSearchAddressBookViewController new];
    [self.navigationController pushViewController:sabVC animated:YES];
}
- (void)rightItemClick {
    QLSearchContactsViewController *scVC = [QLSearchContactsViewController new];
    [self.navigationController pushViewController:scVC animated:YES];
}
- (void)naviSet {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"addressAdd"] originalImage] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-100, 30)];
    self.searchBar.frame = titleView.bounds;
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLNewFriendCell" bundle:nil] forCellReuseIdentifier:@"newFriendCell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell" forIndexPath:indexPath];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    UILabel *lb = [UILabel new];
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = [UIColor colorWithHexString:@"#999999"];
    lb.text = @"时间";
    [headerView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.mas_equalTo(18);
    }];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - Lazy
- (QLBaseSearchBar *)searchBar {
    if(!_searchBar) {
        _searchBar = [QLBaseSearchBar new];
        _searchBar.noEditClick = YES;
        _searchBar.isRound = YES;
        [_searchBar setImage:[UIImage imageNamed:@"newFriendSearchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_searchBar setBjColor:[UIColor groupTableViewBackgroundColor]];
        _searchBar.placeholder = @"搜索";
        _searchBar.extenDelegate = self;
        
    }
    return _searchBar;
}


@end
