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
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderDidPull)];
    
    self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterDidPull)];
}

- (void)refreshHeaderDidPull {
    [self.tableView.mj_header beginRefreshing];
    self.tableView.page = 0;
    if (self.refreshBlock) {
        
        [self.dataArray removeAllObjects];
        self.tableView.page = 0;
        self.refreshBlock(0);
    }
}

- (void)refreshFooterDidPull {
    [self.tableView.mj_footer beginRefreshing];
    if (self.refreshBlock) {
        self.refreshBlock(1);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = @{};
    if ((indexPath.section <= self.dataArray.count)&&self.dataArray.count>0) {
        dic = self.dataArray[indexPath.section];
    }
    if (indexPath.row == 0) {
        QLCarCircleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.headBtnTop.constant = 15;
        cell.openBtnBottom.constant = 0;
        cell.dataDic = dic;
        [cell upDateWithDic:dic];
        return cell;
    } else if (indexPath.row == 1) {
        QLTopCarSourcePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topCarSourcePriceCell" forIndexPath:indexPath];
        // 批发价
        if ([dic objectForKey:@"wholesale_price"]) {
            float wholesale_price = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"wholesale_price"]] floatValue];
            cell.pifaPrice = [[QLToolsManager share] unitConversion:wholesale_price];
        }
        // 零售价
        if ([dic objectForKey:@"sell_price"]) {
            float sell_price = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"sell_price"]] floatValue];
            cell.lingshouPrice = [[QLToolsManager share] unitConversion:sell_price];
        }
        
        cell.chatBlock = ^{
            NSDictionary *accountdic = [dic objectForKey:@"account"];
            [[QLToolsManager share] contactCustomerService:EncodeStringFromDic(accountdic, @"mobile")];
        };
        return cell;
    } else  {
        QLCarCircleImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imgCell" forIndexPath:indexPath];
        cell.bjViewBottom.constant = 15;
        cell.dataType = ImageType;//indexPath.section/2==0?ImageType:VideoType;
        if ([dic objectForKey:@"car_attr_list"]) {
            NSArray *array = [dic objectForKey:@"car_attr_list"];
            if ([array isKindOfClass:[NSArray class]]) {
                cell.dataArr = [array mutableCopy];
            }
        }
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

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
