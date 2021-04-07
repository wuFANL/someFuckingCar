//
//  QLSysMsgListViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/11.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLSysMsgListViewController.h"
#import "QLSysMsgListCell.h"

@interface QLSysMsgListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLSysMsgListViewController
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
//全部已读按钮点击
- (void)rightItemClick {
    
}
//导航栏
- (void)naviSet {
    self.navigationItem.title = self.groupTitle;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"全部已读" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark -tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSysMsgListCell" bundle:nil] forCellReuseIdentifier:@"msgListCell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLSysMsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgListCell" forIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    //时间
    UILabel *timeLB = [UILabel new];
    timeLB.backgroundColor = [UIColor colorWithHexString:@"D4D4D4"];
    timeLB.textColor = WhiteColor;
    timeLB.font = [UIFont systemFontOfSize:13];
    timeLB.textAlignment = NSTextAlignmentCenter;
    timeLB.text = @"时间";
    [headerView addSubview:timeLB];
    [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(10);
        make.centerX.equalTo(headerView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo([timeLB.text widthWithFont:timeLB.font]+10);
    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

@end
