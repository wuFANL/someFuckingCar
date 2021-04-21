//
//  QLTopCarSourceViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/24.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLTopCarSourceViewController.h"
#import "QLCarCircleTextCell.h"
#import "QLTopCarSourcePriceCell.h"
#import "QLCarCircleImgCell.h"
#import <MJRefresh.h>
@interface QLTopCarSourceViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLTopCarSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableView
    [self tableViewSet];
    
}

- (void)endRefresh{
    
}


#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.page = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLTopCarSourcePriceCell" bundle:nil] forCellReuseIdentifier:@"topCarSourcePriceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleImgCell" bundle:nil] forCellReuseIdentifier:@"imgCell"];
    
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderDidPull)];
}


- (void)refreshHeaderDidPull{
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QLCarCircleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.headBtnTop.constant = 15;
        cell.openBtnBottom.constant = 0;
        
        return cell;
    } else if (indexPath.row == 1) {
        QLTopCarSourcePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topCarSourcePriceCell" forIndexPath:indexPath];
        
        
        return cell;
    } else  {
        QLCarCircleImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imgCell" forIndexPath:indexPath];
        cell.bjViewBottom.constant = 15;
        cell.dataType = indexPath.section/2==0?ImageType:VideoType;
        cell.dataArr = [@[@"1",@"2",@"3",@"4"] mutableCopy];
        return cell;
    } 

}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


@end
