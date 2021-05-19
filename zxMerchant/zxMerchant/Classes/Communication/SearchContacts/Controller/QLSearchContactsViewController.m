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
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation QLSearchContactsViewController

#pragma mark - request
-(void)requestForMyFirends
{
    if([NSString isEmptyString:self.searchBar.text])
    {
        return;
    }
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:UserPath params:@{@"operation_type":@"find_friend",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"friend_condition":self.searchBar.text} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];

        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[[response objectForKey:@"result_info"] objectForKey:@"account_list"]];
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    //导航栏
    [self naviSet];
    //tableView
    [self tableViewSet];
}
#pragma mark - action
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self requestForMyFirends];
}
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
    return [self.dataArray count] + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"searchFriendIcon"];
        NSString *searchContent = self.searchBar.text;
        NSString *title = [NSString stringWithFormat:@"搜索:%@",searchContent];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor darkTextColor]}];
        [attStr addAttributes:@{NSForegroundColorAttributeName:GreenColor} range:[title rangeOfString:searchContent]];
        cell.textLabel.attributedText = attStr;
    }
    else
    {
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row - 1];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"head_pic"]]];
        cell.textLabel.text = [dic objectForKey:@"nickname"];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
    {
        [self requestForMyFirends];
    }
    else
    {
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row - 1];
        QLContactsInfoViewController *ciVC = [[QLContactsInfoViewController alloc] initWithFirendID:[dic objectForKey:@"account_id"]];
        ciVC.contactRelation = Friend;
        [self.navigationController pushViewController:ciVC animated:YES];
    }
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
