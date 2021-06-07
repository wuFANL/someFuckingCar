//
//  QLDueProcessViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/10.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLDueProcessViewController.h"
#import "QLDueProcessCell.h"
#import "QLChooseTimeView.h"

@interface QLDueProcessViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) QLBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation QLDueProcessViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.navigationItem.title = self.viewType == 0?@"年检到期":@"强制险到期";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self requestForList];
}
#pragma mark -network
//列表数据
- (void)dataRequest {
    
    [self requestForList];
}

-(void)requestForList
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:VehiclePath params:@{@"operation_type":self.viewType == 0?@"get_merchant_car_list_by_mot":@"get_merchant_car_list_by_insure",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"page_no":@(self.tableView.page),@"page_size":@"20"} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];

        if (self.tableView.page == 1) {
            [self.listArr removeAllObjects];
        }
        NSArray *temArr = [NSArray arrayWithArray:[[response objectForKey:@"result_info"] objectForKey:@"car_list"]];
        [self.listArr addObjectsFromArray:temArr];
        //无数据设置
        if (self.listArr.count == 0) {
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
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:error.domain];
    }];
}

//处理数据
- (void)doTimeRequest:(NSString *)timeStr btnIndex:(NSInteger)index{
    NSDictionary *dic = [self.listArr objectAtIndex:index];
    NSString *carID = [dic objectForKey:@"id"];
    if(self.viewType == 0)
    {
        [MBProgressHUD showCustomLoading:@""];
        [QLNetworkingManager postWithUrl:VehiclePath params:@{@"operation_type":@"update",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"car_id":carID,@"mot_date":timeStr,@"operation_type":@"update_time"} success:^(id response) {
            [MBProgressHUD immediatelyRemoveHUD];
            [MBProgressHUD showSuccess:@"操作成功"];
            
            [self requestForList];

        } fail:^(NSError *error) {
            [MBProgressHUD showError:error.domain];
        }];
    }
    else
    {
        [MBProgressHUD showCustomLoading:@""];
        [QLNetworkingManager postWithUrl:VehiclePath params:@{@"operation_type":@"update",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"car_id":carID,@"insure_date":timeStr,@"operation_type":@"update_time"} success:^(id response) {
            [MBProgressHUD immediatelyRemoveHUD];
            [MBProgressHUD showSuccess:@"操作成功"];
            [self requestForList];

        } fail:^(NSError *error) {
            [MBProgressHUD showError:error.domain];
        }];
        
    }
    

}
#pragma mark -action
//处理事件
- (void)doBtnClick:(UIButton *)sender {
    NSInteger row = sender.tag;
    WEAKSELF
    QLChooseTimeView *ctView = [QLChooseTimeView new];
    ctView.columns = 3;
    ctView.showUnit = YES;
    ctView.titleLB.text = @"确认处理时间";
    ctView.currentDate = [NSDate date];
    ctView.resultBackBlock = ^(NSString *time) {
        //处理请求
        [weakSelf doTimeRequest:time btnIndex:row];
    };
    [ctView showTimeView];
}
#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLDueProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dueCell" forIndexPath:indexPath];
    
    NSDictionary *dic = [self.listArr objectAtIndex:indexPath.row];
    cell.doBtn.tag = indexPath.row;
    [cell.doBtn setTitle:@"待处理" forState:UIControlStateNormal];
    [cell.doBtn addTarget:self action:@selector(doBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"car_img"]]];
    cell.titleLB.text = [dic objectForKey:@"model"];
    cell.priceLB.text = [[QLToolsManager share] unitConversion:[[dic objectForKey:@"sell_price"] floatValue]];
    cell.accLB.text = self.viewType == 0?@"年检到期日":@"强制险到期日";
    NSString *str = [dic objectForKey:@"mot_date"];
    NSArray *ar = [str componentsSeparatedByString:@" "];
    NSString *time = self.viewType == 0?[ar firstObject]:@"2019.02.10";
    cell.timeLB.text = time;
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}
#pragma mark -lazyLoading
- (QLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.extendDelegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"QLDueProcessCell" bundle:nil] forCellReuseIdentifier:@"dueCell"];
        _tableView.showHeadRefreshControl = YES;
        _tableView.showFootRefreshControl = YES;
    }
    return _tableView;
}
- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
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
