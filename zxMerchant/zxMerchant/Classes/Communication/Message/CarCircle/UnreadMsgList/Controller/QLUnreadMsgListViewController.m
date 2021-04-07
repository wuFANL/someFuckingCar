//
//  QLUnreadMsgListViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLUnreadMsgListViewController.h"
#import "QLUnreadMsgListCell.h"
#import "QLRidersDynamicDetailViewController.h"

@interface QLUnreadMsgListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLUnreadMsgListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //tableView
    [self tableViewSet];
}
#pragma mark - action
//更多消息
- (void)moreBtnClick {
    
}
//清空
- (void)rightItemClick {
    
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 72, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLUnreadMsgListCell" bundle:nil] forCellReuseIdentifier:@"unreadMsgListCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLUnreadMsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unreadMsgListCell" forIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QLRidersDynamicDetailViewController *rddVC = [QLRidersDynamicDetailViewController new];
    [self.navigationController pushViewController:rddVC animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    
    QLBaseButton *moreBtn = [QLBaseButton new];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [moreBtn setTitle:@"查看更早的消息..." forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(footerView);
        make.height.mas_equalTo(20);
    }];
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

@end
