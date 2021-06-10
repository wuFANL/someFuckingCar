//
//  QLCarCellDetailViewController.m
//  zxMerchant
//
//  Created by HK on 2021/6/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLCarCellDetailViewController.h"
#import "QLCarCellDtlCell.h"
#import "QLMyCarDetailViewController.h"
@interface QLCarCellDetailViewController ()
@property (nonatomic, assign) NSInteger btnIndex;
@property (nonatomic, strong) NSDictionary *currentDic;
@property (nonatomic, strong) NSMutableArray *sourceAr;
@end

@implementation QLCarCellDetailViewController

-(id)initWithSourceDic:(NSDictionary *)sourceDic withBtnIndex:(NSInteger)btnIndex {
    self = [super init];
    if (self) {
        self.btnIndex = btnIndex;
        self.currentDic = [sourceDic copy];
    }
    return self;
}

-(IBAction)actionTapCarDetail:(id)sender
{
    NSString *fromUserID = [self.currentDic objectForKey:@"account_id"];
    NSString *carid = [self.currentDic objectForKey:@"id"];
    NSString *buscarid = [self.currentDic objectForKey:@"business_car_id"];
    //上架通知 + 交易通知 + 出售通知
    QLMyCarDetailViewController *vcdVC = [[QLMyCarDetailViewController alloc] initWithUserid:fromUserID carID:carid businessCarID:buscarid];
    vcdVC.refuseStr = [self.currentDic objectForKey:@"exam_remark"];
    //0 拒绝  1自己 显示底部   2非自己 隐藏底部
    if([[QLUserInfoModel getLocalInfo].account.account_id isEqualToString:[self.currentDic objectForKey:@"seller_id"]])
    {
        vcdVC.bottomType = @"1";
        if([[self.currentDic objectForKey:@"deal_state"] intValue] ==  1)
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
    else if([[self.currentDic objectForKey:@"exam_status"] intValue] == 2)
    {
        vcdVC.bottomType = @"0";
    }
    else
    {
        vcdVC.bottomType = @"2";

    }
    
    if([self.currentDic objectForKey:@"seller_id"])
    [self.navigationController pushViewController:vcdVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sourceAr = [[NSMutableArray alloc] initWithCapacity:0];
    [self tableViewSet];
    [self.headImg roundRectCornerRadius:6.0 borderWidth:1.0 borderColor:[UIColor whiteColor]];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[self.currentDic objectForKey:@"seller_head_pic"]]];
    self.titleLab.text = [self.currentDic objectForKey:@"model"];
    
    switch (self.btnIndex) {
        case 0:
        {
            [self setTitle:@"帮卖车友"];
            self.contentLab.text = [NSString stringWithFormat:@"%@人帮卖",[self.currentDic objectForKey:@"help_sell_num"]];
        }
            break;
        case 1:
        {
            [self setTitle:@"询价车友"];
            self.contentLab.text = [NSString stringWithFormat:@"%@人询价",[self.currentDic objectForKey:@"trade_num"]];
        }
            break;
        case 2:
        {
            [self setTitle:@"浏览车友"];
            self.contentLab.text = [NSString stringWithFormat:@"%@次浏览",[self.currentDic objectForKey:@"visit_num"]];
        }
            break;
            
        default:
            break;
    }
    
    [self requestForList];
}

-(void)requestForList
{
    NSString *paramStr = @"";
    switch (self.btnIndex) {
        case 0:
        {
            paramStr = @"car/help_sell_list";
        }
            break;
        case 1:
        {
            paramStr = @"car/trade_list";
        }
            break;
        case 2:
        {
            paramStr = @"car/visit_list";
        }
            break;
            
        default:
            break;
    }
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":paramStr,@"car_id":[self.currentDic objectForKey:@"id"],@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"page_size":@"20",@"page_no":@(self.tableView.page)} success:^(id response) {
        if (self.tableView.page == 1) {
            [self.sourceAr removeAllObjects];
        }
        NSArray *temArr = nil;
        if(self.btnIndex == 2)
        {
            temArr = [[response objectForKey:@"result_info"] objectForKey:@"visit_list"];
        }
        else
        {
            temArr = [[response objectForKey:@"result_info"] objectForKey:@"trade_list"];
        }
        [self.sourceAr addObjectsFromArray:temArr];
        //无数据设置
        if (self.sourceAr.count == 0) {
            self.tableView.hidden = YES;
            self.showNoDataView = YES;
        } else {
            self.tableView.hidden = NO;
            self.showNoDataView = NO;
        }
        //刷新设置
        [self.tableView.mj_header endRefreshing];
        if (temArr.count == 20) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //刷新
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCellDtlCell" bundle:nil] forCellReuseIdentifier:@"QLCarCellDtlCell"];
    self.tableView.showHeadRefreshControl = YES;
    self.tableView.showFootRefreshControl = YES;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(120);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sourceAr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLCarCellDtlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QLCarCellDtlCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *modelDic = [self.sourceAr objectAtIndex:indexPath.row];
    if(self.btnIndex == 2)
    {
        cell.rightTimeLab.hidden = YES;
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[modelDic objectForKey:@"head_pic"]]];
        cell.nameLab.text = [modelDic objectForKey:@"nickname"];
        cell.numberLab.text = [NSString stringWithFormat:@"浏览次数：%@",[[modelDic objectForKey:@"visit_times"] stringValue]];
        cell.btmTimeLab.text = [NSString stringWithFormat:@"浏览时间：%@",[modelDic objectForKey:@"visit_date"]];
   
    }
    else
    {
        cell.rightTimeLab.hidden = NO;
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[[modelDic objectForKey:@"buyer_info"] objectForKey:@"head_pic"]]];
        cell.nameLab.text = [[modelDic objectForKey:@"buyer_info"] objectForKey:@"nickname"];
        cell.numberLab.text = [[modelDic objectForKey:@"car_info"] objectForKey:@"model"];
        cell.btmTimeLab.text = [[modelDic objectForKey:@"last_trade_detail"] objectForKey:@"content"];
        cell.rightTimeLab.text = [[modelDic objectForKey:@"last_trade_detail"] objectForKey:@"create_time"];
    }

    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
