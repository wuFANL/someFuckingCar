//
//  QLHelpSellViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLHelpSellViewController.h"
#import "QLChooseHeadView.h"
#import "QLHelpSellCell.h"

@interface QLHelpSellViewController ()<QLBaseSearchBarDelegate,QLChooseHeadViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseSearchBar *searchBar;
@property (nonatomic, strong) QLChooseHeadView *headView;

@end

@implementation QLHelpSellViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self naviSet];
    //头部
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    //tableView
    [self tableViewSet];
}
#pragma mark - action
//头部选择样式设置
- (void)chooseTitleStyle:(UIButton *)chooseBtn Index:(NSInteger)index {
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
}
//头部选择点击
- (void)chooseSelect:(UIButton *)lastBtn CurrentBtn:(UIButton *)currentBtn Index:(NSInteger)index {
    lastBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    currentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
   
}
//右导航按钮
- (void)rightItemClick {
    
}
//导航栏
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
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 68, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLHelpSellCell" bundle:nil] forCellReuseIdentifier:@"helpSellCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLHelpSellCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpSellCell" forIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
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
- (QLChooseHeadView *)headView {
    if (!_headView) {
        _headView = [QLChooseHeadView new];
        _headView.column = 5;
        _headView.typeArr = @[@"全部",@"待洽谈",@"洽谈中",@"已成交"];
        _headView.lineColor = GreenColor;
        _headView.lineWidth = 10;
        _headView.typeDelegate = self;
    }
    return _headView;
}
@end
