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
#import "QLContactsInfoViewController.h"

@interface QLNewFriendViewController ()<QLBaseSearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation QLNewFriendViewController

-(void)requestForNewFriendList
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"pre_list",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[[response objectForKey:@"result_info"] objectForKey:@"account_list"]];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForAddFriend:(NSInteger)tag
{
    NSDictionary *dic = [self.dataArray objectAtIndex:tag];
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"add",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"to_account_id":[dic objectForKey:@"account_id"],@"remark":@""} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self requestForNewFriendList];

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
    [self requestForNewFriendList];
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell" forIndexPath:indexPath];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"head_pic"]]];
    cell.nameLB.text = [dic objectForKey:@"nickname"];
    cell.mobileLB.text = [dic objectForKey:@"mobile"];
    WEAKSELF
    [cell setBtnTBlock:^(NSInteger tag) {
        [weakSelf requestForAddFriend:tag];
    }];
    cell.collectionBtn.tag = indexPath.row;
    [cell.collectionBtn setTitle:[[dic objectForKey:@"attention_flag"] intValue]==1?@"已关注":@"+ 关注" forState:UIControlStateNormal];
    cell.collectionBtn.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:161.0/255.0 blue:48.0/255.0 alpha:1.0];
    [cell.collectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if([[dic objectForKey:@"attention_flag"] intValue] == 1)
    {
        [cell.collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cell.collectionBtn.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    QLContactsInfoViewController *ciVC = [[QLContactsInfoViewController alloc] initWithFirendID:[dic objectForKey:@"account_id"]];
    ciVC.contactRelation = Friend;
    [self.navigationController pushViewController:ciVC animated:YES];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    UILabel *lb = [UILabel new];
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = [UIColor colorWithHexString:@"#999999"];
//    lb.text = @"时间";
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
    return 10;
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
