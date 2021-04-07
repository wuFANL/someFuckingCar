//
//  QLMySubscriptionsPageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/27.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLMySubscriptionsPageViewController.h"
#import "QLNoSubscriptionsView.h"
#import "QLSubListTitleCell.h"
#import "QLHomeCarCell.h"
#import "QLSubListMoreCell.h"
#import "QLMySubscriptionsDetailViewController.h"
#import "QLAdvancedScreeningViewController.h"

@interface QLMySubscriptionsPageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation QLMySubscriptionsPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //设置导航
    [self setNavi];
    
    //背景
    self.showBackgroundView = NO;
    QLNoSubscriptionsView *subView = [QLNoSubscriptionsView new];
    [self.backgroundView addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView);
    }];
    
    //tableView
    [self tableViewSet];
}

#pragma mark - navigation
//添加订阅
- (void)addSubClick {
    //筛选
    QLAdvancedScreeningViewController *asVC = [QLAdvancedScreeningViewController new];
    asVC.showCity = NO;
    asVC.isSubscription = YES;
    [self.navigationController pushViewController:asVC animated:YES];
}
//设置导航
- (void)setNavi {
    self.navigationItem.title = @"我的订阅";
    //右导航按钮
    UIButton *rightBtn = [UIButton new];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [rightBtn setTitle:@"添加订阅" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addSubClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSubListTitleCell" bundle:nil] forCellReuseIdentifier:@"subListTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLHomeCarCell" bundle:nil] forCellReuseIdentifier:@"hCarCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSubListMoreCell" bundle:nil] forCellReuseIdentifier:@"subListMoreCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2+self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QLSubListTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subListTitleCell" forIndexPath:indexPath];
        cell.iconArr = [@[@"1",@"2",@"3"] mutableCopy];
        return cell;
    } else if (indexPath.row == ([tableView numberOfRowsInSection:indexPath.section]-1)) {
        QLSubListMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subListMoreCell" forIndexPath:indexPath];
        
        return cell;
    } else {
        QLHomeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hCarCell" forIndexPath:indexPath];
        cell.lineView.hidden = NO;
        return cell;

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QLMySubscriptionsDetailViewController *msdVC = [QLMySubscriptionsDetailViewController new];
    [self.navigationController pushViewController:msdVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 90;
    } else if (indexPath.row == self.listArr.count+1) {
        return 48;
    } else {
        return 120;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [QLToolsManager cellSetRound:tableView Cell:cell IndexPath:indexPath SideSpace:0];
}
#pragma mark - Lazy
- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray arrayWithArray:@[@"1",@"2"]];
    }
    return _listArr;
}
@end
