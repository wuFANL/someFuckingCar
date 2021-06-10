//
//  QLCarDealersViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/6/8.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLCarDealersViewController.h"
#import "QLChooseHeadView.h"
#import "QLCarDealersCell.h"
#import "QLCarDealersModel.h"
#import "QLContactsInfoViewController.h"
#import "QLChatListPageViewController.h"

@interface QLCarDealersViewController ()<QLChooseHeadViewDelegate,UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) QLChooseHeadView *chooseView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) NSArray *keyArr;
@property (nonatomic, strong) NSMutableDictionary *listDic;
@end

@implementation QLCarDealersViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车商友";
    //头部
    [self.view addSubview:self.chooseView];
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    //tableView
    [self tableViewCommon];
    
}
#pragma mark - network
//关注
- (void)collectRequest:(FriendDetailModel *)model {
    if ([model.account_id isEqualToString:[QLUserInfoModel getLocalInfo].account.account_id]) {
        [MBProgressHUD showError:@"自己不能关注自己"];
        return;
    }
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"add",@"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id),@"to_account_id":model.account_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        model.state = model.state.integerValue==1?@"0":@"1";
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
//列表数据
- (void)dataRequest {
    [self getRecordRequest];
    NSDictionary *param;
    if (self.chooseView.selectedIndex == 0) {
        param = @{@"operation_type":@"car/visit_list",
                  @"page_no":@(self.tableView.page),
                  @"page_size":@(listShowCount)
        };
    } else if (self.chooseView.selectedIndex == 1) {
        param = @{@"operation_type":@"car/trade_list",
                  @"page_no":@(self.tableView.page),
                  @"page_size":@(listShowCount)
        };
    } else {
        param = @{@"operation_type":@"car/help_sell_list",
                  @"page_no":@(self.tableView.page),
                  @"page_size":@(listShowCount)
        };
    }
    
    [QLNetworkingManager postWithUrl:BusinessPath params:param success:^(id response) {
        if (self.tableView.page == 1) {
            [self.listArr removeAllObjects];
        }
        NSArray *temArr = nil;
        if (self.chooseView.selectedIndex == 0) {
            temArr = [NSArray yy_modelArrayWithClass:[FriendDetailModel class] json:response[@"result_info"][@"visit_list"]];
        } else {
            temArr = [NSArray yy_modelArrayWithClass:[QLCarDealersModel class] json:response[@"result_info"][@"trade_list"]];
        }
        
        [self.listArr addObjectsFromArray:temArr];
        //数据筛选
        [self.listDic removeAllObjects];
        for (id temModel in self.listArr) {
            if (self.chooseView.selectedIndex == 0) {
                FriendDetailModel *model = temModel;
                NSString *timeStr = [model.visit_date componentsSeparatedByString:@" "].firstObject;
                if (timeStr.length != 0) {
                    id value = self.listDic[timeStr];
                    if ([value isKindOfClass:[NSMutableArray class]]) {
                        [((NSMutableArray *)value) addObject:model];
                    } else {
                        value = [NSMutableArray arrayWithObject:model];
                    }
                    self.listDic[timeStr] = value;
                }
            } else {
                QLCarDealersModel *model = temModel;
                NSString *timeStr = [model.last_trade_detail.create_time componentsSeparatedByString:@" "].firstObject;
                if (timeStr.length != 0) {
                    id value = self.listDic[timeStr];
                    if ([value isKindOfClass:[NSMutableArray class]]) {
                        [((NSMutableArray *)value) addObject:model];
                    } else {
                        value = [NSMutableArray arrayWithObject:model];
                    }
                    self.listDic[timeStr] = value;
                }
            }
        }
        //排序
        self.keyArr = [self.listDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat: @"yyyy-MM-dd"];
            
            NSDate *date1= [dateFormatter dateFromString:obj1];
            
            NSDate *date2= [dateFormatter dateFromString:obj2];
            
            if (date1 == [date1 earlierDate: date2]) {
                
                return NSOrderedDescending;//降序
                
            } else if (date1 == [date1 laterDate: date2]) {
                
                return NSOrderedAscending;//升序
                
            } else{

                return NSOrderedSame;//相等
            }
        }];
        
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
        if (temArr.count == listShowCount) {
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
//记录数据
- (void)getRecordRequest {
    [QLNetworkingManager postWithUrl:CarPath params:@{@"operation_type":@"m_statistic",@"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id),@"business_id":QLNONull([QLUserInfoModel getLocalInfo].business.business_id)} success:^(id response) {
        NSDictionary *dic = response[@"result_info"];
    
        UIButton *btn1 = self.chooseView.btnArr[0];
        [btn1 setTitle:StringWithFormat(@"今日访客%@", dic[@"visit_today_count"]) forState:UIControlStateNormal];
        
        UIButton *btn2 = self.chooseView.btnArr[1];
        [btn2 setTitle:StringWithFormat(@"今日询价%@", dic[@"trade_today_count"]) forState:UIControlStateNormal];
        
        UIButton *btn3 = self.chooseView.btnArr[2];
        [btn3 setTitle:StringWithFormat(@"今日帮卖%@", dic[@"help_sell_today_count"]) forState:UIControlStateNormal];
    
    
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - action
//关注
- (void)gzBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        NSInteger section = sender.tag/1000;
        NSInteger row = sender.tag%1000;
        id value = self.listDic[ self.keyArr[section] ];
        if ([value isKindOfClass:[NSArray class]]) {
            FriendDetailModel *model = ((NSArray *) value)[row];
            
            [self collectRequest:model];
        }
    }
}
//头部选择样式设置
- (void)chooseTitleStyle:(UIButton *)chooseBtn Index:(NSInteger)index {
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [chooseBtn setTitleColor:GreenColor forState:UIControlStateSelected];
    
}
//头部选择点击
- (void)chooseSelect:(UIButton *)lastBtn CurrentBtn:(UIButton *)currentBtn Index:(NSInteger)index {
    lastBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    currentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    self.tableView.showHeadRefreshControl = YES;
    
}
#pragma mark - tableView
- (void)tableViewCommon {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.extendDelegate = self;
    self.tableView.showHeadRefreshControl = YES;
    self.tableView.showFootRefreshControl = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarDealersCell" bundle:nil] forCellReuseIdentifier:@"carDealersCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.chooseView.mas_bottom);
    }];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keyArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id value = self.listDic[ self.keyArr[section] ];
    if ([value isKindOfClass:[NSArray class]]) {
        return ((NSArray *) value).count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLCarDealersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carDealersCell" forIndexPath:indexPath];
    cell.timeLB.hidden =  self.chooseView.selectedIndex == 0?YES:NO;
    cell.gzBtn.hidden = self.chooseView.selectedIndex == 0?NO:YES;
    cell.gzBtnWidth.constant = self.chooseView.selectedIndex == 0?58:0;
    
    id value = self.listDic[ self.keyArr[indexPath.section] ];
    if ([value isKindOfClass:[NSArray class]]) {
        if (self.chooseView.selectedIndex == 0) {
            FriendDetailModel *model = ((NSArray *) value)[indexPath.row];
            [cell.headBtn sd_setImageWithURL:[NSURL URLWithString:model.head_pic] forState:UIControlStateNormal];
            cell.nameLB.text = model.nickname;
            
            NSString *timeStr = [model.visit_date componentsSeparatedByString:@" "].lastObject;
            cell.accALB.text = [NSString stringWithFormat:@"%@:%@访问",[timeStr componentsSeparatedByString:@":"][0],[timeStr componentsSeparatedByString:@":"][1]];
            cell.gzBtn.hidden = [model.account_id isEqualToString:[QLUserInfoModel getLocalInfo].account.account_id]?YES:NO;
            cell.gzBtn.tag = indexPath.section*1000+indexPath.row;
            [cell.gzBtn addTarget:self action:@selector(gzBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.gzBtn.selected = model.state.integerValue==1?YES:NO;
        } else {
            QLCarDealersModel *model = ((NSArray *) value)[indexPath.row];
            [cell.headBtn sd_setImageWithURL:[NSURL URLWithString:model.buyer_info.head_pic] forState:UIControlStateNormal];
            cell.nameLB.text = model.buyer_info.nickname;
            cell.accALB.text = model.car_info.model;
            cell.accBLB.text = model.last_trade_detail.content;
            
            NSString *timeStr = [model.last_trade_detail.create_time componentsSeparatedByString:@" "].lastObject;
            cell.timeLB.text = [NSString stringWithFormat:@"%@:%@",[timeStr componentsSeparatedByString:@":"][0],[timeStr componentsSeparatedByString:@":"][1]];
        }
    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id value = self.listDic[ self.keyArr[indexPath.section] ];
    if ([value isKindOfClass:[NSArray class]]) {
        if (self.chooseView.selectedIndex == 0) {
            FriendDetailModel *model = ((NSArray *) value)[indexPath.row];
            QLContactsInfoViewController *ciVC = [[QLContactsInfoViewController alloc] initWithFirendID:model.account_id];
            ciVC.contactRelation = Friend;
            [self.navigationController pushViewController:ciVC animated:YES];
        } else {
            QLCarDealersModel *model = ((NSArray *) value)[indexPath.row];
            QLChatListPageViewController *clpVC = [[QLChatListPageViewController alloc] initWithCarID:@"" messageToID:model.buyer_info.account_id];
            clpVC.navigationItem.title = model.buyer_info.nickname;
            [self.navigationController pushViewController:clpVC animated:YES];
        }
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = WhiteColor;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(15);
        make.centerY.equalTo(headerView);
    }];
    NSArray *timeArr = [((NSString *) self.keyArr[section]) componentsSeparatedByString:@"-"];
    NSString *timeStr = [NSString stringWithFormat:@"%@月%@日",timeArr[1],timeArr[2]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:timeStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    label.attributedText = string;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return self.chooseView.selectedIndex == 0?75:100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - Lazy
- (QLChooseHeadView *)chooseView {
    if (!_chooseView) {
        _chooseView = [QLChooseHeadView new];
        _chooseView.column = 3;
        _chooseView.typeArr = @[@"今日访客0",@"今日询价0",@"今日帮卖0"];
        _chooseView.lineColor = GreenColor;
        _chooseView.lineWidth = 10;
        _chooseView.typeDelegate = self;
    }
    return _chooseView;
}
- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}
- (NSMutableDictionary *)listDic {
    if (!_listDic) {
        _listDic = [NSMutableDictionary dictionary];
    }
    return _listDic;
}

@end
