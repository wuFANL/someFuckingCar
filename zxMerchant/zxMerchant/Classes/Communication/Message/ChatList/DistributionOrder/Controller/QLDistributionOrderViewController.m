//
//  QLDistributionOrderViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLDistributionOrderViewController.h"
#import "QLNewFriendCell.h"

@interface QLDistributionOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLDistributionOrderViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"派单";
    //tableView
    [self tableViewSet];
    
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLNewFriendCell" bundle:nil] forCellReuseIdentifier:@"newFriendCell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell" forIndexPath:indexPath];
    [cell.collectionBtn setBackgroundImage:[UIImage imageNamed:@"greenBj_332"] forState:UIControlStateNormal];
    [cell.collectionBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [cell.collectionBtn setTitle:@"派单" forState:UIControlStateNormal];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
