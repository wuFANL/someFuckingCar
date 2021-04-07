//
//  QLSearchContactsViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/7.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLSearchContactsViewController.h"
#import "QLContactsInfoViewController.h"

@interface QLSearchContactsViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseSearchBar *searchBar;

@end

@implementation QLSearchContactsViewController
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
#pragma mark - action
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.tableView reloadData];
}
- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)naviSet {
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-100, 30)];
    self.searchBar.frame = titleView.bounds;
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    leftItem.width = 10;
    self.navigationItem.leftBarButtonItems = @[leftItem];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:@"searchFriendIcon"];
    
    NSString *searchContent = self.searchBar.text;
    NSString *title = [NSString stringWithFormat:@"搜索:%@",searchContent];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor darkTextColor]}];
    [attStr addAttributes:@{NSForegroundColorAttributeName:GreenColor} range:[title rangeOfString:searchContent]];
    cell.textLabel.attributedText = attStr;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QLContactsInfoViewController *ciVC = [QLContactsInfoViewController new];
    [self.navigationController pushViewController:ciVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - Lazy
- (QLBaseSearchBar *)searchBar {
    if(!_searchBar) {
        _searchBar = [QLBaseSearchBar new];
        _searchBar.delegate = self;
    }
    return _searchBar;
}
@end
