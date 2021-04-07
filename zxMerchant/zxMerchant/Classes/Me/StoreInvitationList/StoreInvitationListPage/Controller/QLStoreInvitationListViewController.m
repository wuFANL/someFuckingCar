//
//  QLStoreInvitationListViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/1/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLStoreInvitationListViewController.h"
#import "QLStoreInvitationListCell.h"
#import "QLStoreInvitationDetailViewController.h"

@interface QLStoreInvitationListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLStoreInvitationListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺邀请";
    //tableView
    [self tableViewSet];
    
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLStoreInvitationListCell" bundle:nil] forCellReuseIdentifier:@"storeInvitationListCell"];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLStoreInvitationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeInvitationListCell" forIndexPath:indexPath];
   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QLStoreInvitationDetailViewController *sidVC = [QLStoreInvitationDetailViewController new];
    [self.navigationController pushViewController:sidVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


@end
