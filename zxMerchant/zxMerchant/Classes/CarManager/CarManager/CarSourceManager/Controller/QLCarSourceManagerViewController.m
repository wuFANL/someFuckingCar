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
#import "QLCarCellDetailViewController.h"

@interface QLCarSourceManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *sourceAr;
@end

@implementation QLCarSourceManagerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceAr = [[NSMutableArray alloc] initWithCapacity:0];
    //tableView
    [self tableViewSet];
}

-(void)uploadTableWithSourceArray:(NSMutableArray *)sourceArray {
    [self.sourceAr removeAllObjects];
    [self.sourceAr addObjectsFromArray:sourceArray];
    
    [self.tableView reloadData];
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
    return [self.sourceAr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLCarSourceManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carSourceManagerCell" forIndexPath:indexPath];
    NSDictionary *dic = [self.sourceAr objectAtIndex:indexPath.row];
    [cell setTagBlock:^(NSInteger btnTag) {
       // 0 1 2
        QLCarCellDetailViewController *ctl = [[QLCarCellDetailViewController alloc] initWithSourceDic:dic withBtnIndex:btnTag];
        [self.navigationController pushViewController:ctl animated:YES];
    }];
//    cell.priceBtn.selected = self.type == 2?NO:YES;
    cell.showFunView = self.type == 2?NO:YES;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"car_img"]]];
    cell.activityStatusLB.hidden = YES;
    cell.accImgView.hidden = YES;
    cell.statusBtn.hidden = YES;
    if([[dic objectForKey:@"local_state"] intValue] == 2)
    {
        cell.statusBtn.hidden = NO;
    }
    if([[dic objectForKey:@"exam_status"] intValue] == 98)
    {
        cell.accImgView.hidden = NO;
        cell.accImgView.image = [UIImage imageNamed:@"daishenhe"];

    } else if ([[dic objectForKey:@"exam_status"] intValue] == 2) {
        cell.activityStatusLB.hidden = NO;
        cell.activityStatusLB.backgroundColor = [UIColor redColor];
        cell.activityStatusLB.text = @"未通过";
    }
    cell.titleLB.text = [dic objectForKey:@"model"];
    cell.desLB.text = [NSString stringWithFormat:@"%@ | %@万公里",[dic objectForKey:@"production_year"],[[dic objectForKey:@"driving_distance"] stringValue]];
    
    NSString *moneyStr = [NSString stringWithFormat:@"%@万",[[QLToolsManager share] unitMileage:[[dic objectForKey:@"sell_price"] floatValue]]];
    [cell.priceBtn setTitle:moneyStr forState:UIControlStateNormal];
    cell.prePriceLB.text = [NSString stringWithFormat:@"首付%@万",[[QLToolsManager share] unitMileage:[[dic objectForKey:@"sell_pre_price"] floatValue]]];
    if([[QLUserInfoModel getLocalInfo].account.account_id isEqualToString:[dic objectForKey:@"seller_id"]] && [[dic objectForKey:@"exam_status"] intValue] != 98) {
        cell.lookBtn.hidden = NO;
        cell.callBtn.hidden = NO;
        cell.helpBtn.hidden = NO;
        
        [cell.helpBtn setTitle:[[dic objectForKey:@"help_sell_num"] stringValue] forState:UIControlStateNormal];
        [cell.callBtn setTitle:[[dic objectForKey:@"trade_num"] stringValue] forState:UIControlStateNormal];
        [cell.lookBtn setTitle:[[dic objectForKey:@"visit_num"] stringValue] forState:UIControlStateNormal];
    } else {
        cell.lookBtn.hidden = YES;
        cell.callBtn.hidden = YES;
        cell.helpBtn.hidden = YES;
    }
    
    if([[QLUserInfoModel getLocalInfo].account.flag isEqualToString:@"1"]) {
        cell.activityStatusLB.hidden = YES;
        cell.lookBtn.hidden = YES;
        cell.callBtn.hidden = YES;
        cell.helpBtn.hidden = YES;
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.sourceAr objectAtIndex:indexPath.row];
    if (self.type != 2) {
        NSString *fromUserID = [dic objectForKey:@"account_id"];
        NSString *carid = [dic objectForKey:@"id"];
        NSString *buscarid = [dic objectForKey:@"business_car_id"];
        //上架通知 + 交易通知 + 出售通知
        QLMyCarDetailViewController *vcdVC = [[QLMyCarDetailViewController alloc] initWithUserid:fromUserID carID:carid businessCarID:buscarid];
        vcdVC.refuseStr = [dic objectForKey:@"exam_remark"];
        //0 拒绝  1自己 显示底部   2非自己 隐藏底部
        if([[QLUserInfoModel getLocalInfo].account.account_id isEqualToString:[dic objectForKey:@"seller_id"]])
        {
            vcdVC.bottomType = @"1";
            if([[dic objectForKey:@"deal_state"] intValue] ==  1)
            {
                //1=上架状态（显示下架微店）
                vcdVC.bottomBtnTitle = @"下架微店";
            }
            else
            {
                //0=下架状态（显示上架微店）
                vcdVC.bottomBtnTitle = @"上架微店";

            }
        }
        else if([[dic objectForKey:@"exam_status"] intValue] == 2)
        {
            vcdVC.bottomType = @"0";
        }
        else
        {
            vcdVC.bottomType = @"2";

        }
        
        if([dic objectForKey:@"seller_id"])
        [self.navigationController pushViewController:vcdVC animated:YES];
    
    } else {
        QLCooperativeSourceDetailPageViewController *csdpVC = [[QLCooperativeSourceDetailPageViewController alloc] initWithSourceDic:dic];
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
