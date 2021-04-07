//
//  QLCarSourceManagerViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarSourceManagerViewController.h"
#import "QLCarSourceManagerCell.h"
#import "QLMyCarDetailViewController.h"
#import "QLCooperativeSourceDetailPageViewController.h"

@interface QLCarSourceManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLCarSourceManagerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //tableView
    [self tableViewSet];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarSourceManagerCell" bundle:nil] forCellReuseIdentifier:@"carSourceManagerCell"];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLCarSourceManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carSourceManagerCell" forIndexPath:indexPath];
    cell.priceBtn.selected = self.type == 2?NO:YES;
    cell.showFunView = self.type == 2?NO:YES;
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type != 2) {
        QLMyCarDetailViewController *mcdVC = [QLMyCarDetailViewController new];
        [self.navigationController pushViewController:mcdVC animated:YES];
    } else {
        QLCooperativeSourceDetailPageViewController *csdpVC = [QLCooperativeSourceDetailPageViewController new];
        [self.navigationController pushViewController:csdpVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


@end
