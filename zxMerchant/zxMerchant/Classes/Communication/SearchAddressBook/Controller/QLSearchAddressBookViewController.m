//
//  QLSearchAddressBookViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/10.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLSearchAddressBookViewController.h"
#import "QLSearchHistoryCell.h"
#import "MyFriendsModel.h"
#import "QLListSectionIndexView.h"
#import "QLContactsInfoViewController.h"
@interface QLSearchAddressBookViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, weak) QLBaseSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *hotArr;
@property (nonatomic, strong) NSArray *listArr;

@property (nonatomic, strong) QLListSectionIndexView *indexView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MyFriendsModel *friendListModel;
@end

@implementation QLSearchAddressBookViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self requestForMyFirends];
    
}

#pragma mark - request
-(void)requestForMyFirends
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"list",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.friendListModel = [MyFriendsModel yy_modelWithJSON:[response objectForKey:@"result_info"]];
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[self sortObjectsAccordingToInitialWith:self.friendListModel.account_list]];
        
        //抽出索引
        __block NSMutableArray *bArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self.dataArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FriendDetailModel *model = obj.firstObject;
            [bArray addObject:model.name_index];
        }];
        self.indexView.indexArr = [bArray copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

// 按首字母分组排序数组
-(NSMutableArray *)sortObjectsAccordingToInitialWith:(NSArray *)arr {

    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    //将每个名字分到某个section下
    for (FriendDetailModel *personModel in arr) {
        //获取name属性的值所在的位置，比如L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:@selector(name_index)];
        //把name为“L”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:personModel];
    }
   
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(name_index)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }

    //删除空的数组
    NSMutableArray *finalArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
        }
    }
    return finalArr;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    //设置导航栏
    [self setNavi];
    //tableView
    [self tableViewSet];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
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
    
    [self.dataArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(FriendDetailModel *fobj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([fobj.nickname hasPrefix:searchText])
            {
                
            }
        }];
    }];
    
    
//    [self.tableView reloadData];
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
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 78, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataArray objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    FriendDetailModel *friendModel = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:friendModel.head_pic] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            cell.imageView.image = [UIImage drawWithImage:cell.imageView.image size:CGSizeMake(38, 38)];
            NSIndexPath *indexp = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            [tableView reloadRowsAtIndexPaths:@[indexp] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    cell.textLabel.text = friendModel.nickname;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendDetailModel *friendModel = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    QLContactsInfoViewController *ciVC = [[QLContactsInfoViewController alloc] initWithFirendID:friendModel.account_id];
    ciVC.contactRelation = Friend;
    [self.navigationController pushViewController:ciVC animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    
    UILabel *sectionLB = [UILabel new];
    sectionLB.font = [UIFont systemFontOfSize:11];
    sectionLB.textColor = [UIColor colorWithHexString:@"666666"];
    sectionLB.text = [self.indexView.indexArr objectAtIndex:section];;
    [headerView addSubview:sectionLB];
    [sectionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView).offset(18);
    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark -Lazy
- (QLListSectionIndexView *)indexView {
    if (!_indexView) {
        _indexView = [[QLListSectionIndexView alloc]init];
        _indexView.defaultColor = GreenColor;
        _indexView.relevanceView = self.tableView;
    }
    return _indexView;
}


@end
