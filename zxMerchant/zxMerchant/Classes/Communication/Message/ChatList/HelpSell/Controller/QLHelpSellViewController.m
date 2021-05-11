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
//全部数据组
/** 全部数据*/
@property (nonatomic, strong) NSMutableArray *allDataArr;
// 洽谈中
//state -1是全部 0是待洽谈 1是洽谈中 2是已成交

/** 待洽谈*/
@property (nonatomic, strong) NSMutableArray *waitDataArr;
@property (nonatomic, strong) NSMutableArray *chatDataArr;
@property (nonatomic, strong) NSMutableArray *doneDataArr;

@property (nonatomic, strong) QLBaseTableView *tableView1;
@property (nonatomic, strong) QLBaseTableView *tableView2;
@property (nonatomic, strong) QLBaseTableView *tableView3;
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
    
    // 其余的三个 隐藏
    self.tableView1.hidden = YES;
    self.tableView2.hidden = YES;
    self.tableView3.hidden = YES;
    
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
    
    self.tableView.hidden = YES;
    self.tableView1.hidden = YES;
    self.tableView2.hidden = YES;
    self.tableView3.hidden = YES;

    switch (index) {
        case 0:{
            self.tableView.hidden = NO;}
            break;
        case 1:
        {self.tableView1.hidden = NO;}
            break;
        case 2:
        {self.tableView2.hidden = NO;}
            break;
        case 3:
        {self.tableView3.hidden = NO;}
            break;
        default:
            break;
    }
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
 
    self.tableView1 = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView1.separatorInset = UIEdgeInsetsMake(0, 68, 0, 0);
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.extendDelegate = self;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"QLHelpSellCell" bundle:nil] forCellReuseIdentifier:@"helpSellCell"];
    [self.view insertSubview:self.tableView1 aboveSubview:self.backgroundView];
    [self.tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom);
    }];
    
    
    self.tableView2 = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView2.separatorInset = UIEdgeInsetsMake(0, 68, 0, 0);
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [self.tableView2 registerNib:[UINib nibWithNibName:@"QLHelpSellCell" bundle:nil] forCellReuseIdentifier:@"helpSellCell"];
    [self.view insertSubview:self.tableView2 aboveSubview:self.backgroundView];
    [self.tableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom);
    }];
    
    
    self.tableView3 = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView3.separatorInset = UIEdgeInsetsMake(0, 68, 0, 0);
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    [self.tableView3 registerNib:[UINib nibWithNibName:@"QLHelpSellCell" bundle:nil] forCellReuseIdentifier:@"helpSellCell"];
    [self.view insertSubview:self.tableView3 aboveSubview:self.backgroundView];
    [self.tableView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom);
    }];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
    
    if (tableView == self.tableView) {
        return self.allDataArr.count;
    } else if (tableView == self.tableView1){
        return self.waitDataArr.count;
    } else if (tableView == self.tableView2) {
        return self.chatDataArr.count;
    } else {
        return self.doneDataArr.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLHelpSellCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpSellCell" forIndexPath:indexPath];
    NSDictionary * para;
    if (tableView == self.tableView) {
        para = self.allDataArr[indexPath.row];
    } else if (tableView == self.tableView1 ) {
        para = self.waitDataArr[indexPath.row];
    } else if (tableView == self.tableView2 ) {
        para = self.chatDataArr[indexPath.row];
    } else {
        para = self.doneDataArr[indexPath.row];
    }
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


- (QLBaseTableView *)tableView1 {
    if (!_tableView1) {
        _tableView1 = [[QLBaseTableView alloc] init];
        _tableView1.page = 0;
    }
    return _tableView1;
}
- (QLBaseTableView *)tableView2 {
    if (!_tableView2) {
        _tableView2 = [[QLBaseTableView alloc] init];
        _tableView2.page = 0;
    }
    return _tableView2;
}
- (QLBaseTableView *)tableView3 {
    if (!_tableView3) {
        _tableView3 = [[QLBaseTableView alloc] init];
        _tableView3.page = 0;
    }
    return _tableView3;
}

- (NSMutableArray *)allDataArr {
    if (!_allDataArr) {
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}

-(NSMutableArray *)waitDataArr {
    if (!_waitDataArr) {
        _waitDataArr = [NSMutableArray array];
    }
    return _waitDataArr;
}

- (NSMutableArray *)chatDataArr {
    if (!_chatDataArr) {
        _chatDataArr = [NSMutableArray array];
    }
    return _chatDataArr;
}

- (NSMutableArray *)doneDataArr {
    if (!_doneDataArr ) {
        _doneDataArr = [NSMutableArray array];
    }
    return _doneDataArr;
}
@end
