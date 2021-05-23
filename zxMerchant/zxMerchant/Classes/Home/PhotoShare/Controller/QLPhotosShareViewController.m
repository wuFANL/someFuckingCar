//
//  QLPhotosShareViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/29.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLPhotosShareViewController.h"


@interface QLPhotosShareViewController ()<QLVehicleSortViewDelegate,UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) QLVehicleSortView *headView;
@property (nonatomic, strong) QLVehicleConditionsView *vcView;
//排序
@property (nonatomic, assign) NSInteger sort_by;
//价格区间
@property (nonatomic, strong) NSString *priceRange;
//品牌ID
@property (nonatomic, strong) NSString *brand_id;


@end

@implementation QLPhotosShareViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.vcView hidden];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"多图分享";
    //刷新
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //头部
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    //提交
    UIButton *submitBtn = [UIButton new];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBtn setBackgroundColor:GreenColor];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(44);
    }];
    self.submitBtn = submitBtn;
    //tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(submitBtn.mas_top);
        make.top.equalTo(self.headView.mas_bottom);
    }];
    //默认设置
    self.sort_by = 1;
    self.priceRange = @"0-9999999";
    
}
#pragma mark- network
//数据请求
- (void)dataRequest {
    NSArray *priceArr = [self.priceRange componentsSeparatedByString:@"-"];
    
    NSDictionary *dic = @{@"operation_type":@"get_merchant_car_list",@"member_id":QLNONull([QLUserInfoModel getLocalInfo].member_account.account_id),@"brand_id":QLNONull(self.brand_id),@"price_min":priceArr.count==2?priceArr[0]:@"",@"price_max":priceArr.count==2?priceArr[1]:@"",@"deal_state":@"1",@"page_no":@(self.tableView.page),@"page_size":@(listShowCount),@"sort_by":@(self.sort_by)};
    [QLNetworkingManager postWithUrl:VehiclePath params:dic success:^(id response) {
        self.model = [QLVehiclePageModel yy_modelWithJSON:response[@"result_info"]];
        if (self.tableView.page == 1) {
            [self.dataArr removeAllObjects];
        }
        NSArray *temArr = [NSArray arrayWithArray:self.model.car_list];
        [self.dataArr addObjectsFromArray:temArr];
        if (self.dataArr.count == 0) {
            self.tableView.hidden = YES;
            self.showNoDataView = YES;
        } else {
            self.tableView.hidden = NO;
            self.showNoDataView = NO;
        }
        [self.tableView.mj_header endRefreshing];
        if (temArr.count == listShowCount) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //刷新
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark- action
//刷新
- (void)rightItemClick {
    self.sort_by = 1;
    self.priceRange = @"0-9999999";
    self.brand_id = @"";
    self.headView.dataArr[0] = @"智能排序";
    [self.headView.collectionView reloadData];
    self.tableView.showHeadRefreshControl = YES;
}
//类型变化
- (void)selectTypeBack:(NSInteger)type {
    if (type != 1) {
        NSArray *dataArr = nil;
        NSIndexPath *selectIndexPath = nil;
        if (type == 0) {
            dataArr = @[@"智能排序",@"价格最低",@"价格最高",@"车龄最短",@"里程最少"];
            selectIndexPath = [NSIndexPath indexPathForRow:self.sort_by-1 inSection:0];
        } else if (type == 2) {
            dataArr = @[@"0-9999999",@"0-50000",@"50000-100000",@"100000-150000",@"150000-200000",@"200000-300000",@"300000-500000",@"500000-9999999"];
            selectIndexPath = [NSIndexPath indexPathForRow:[dataArr indexOfObject:self.priceRange] inSection:0];
        }
        self.vcView.selectIndexPath = selectIndexPath;
        self.vcView.type = type==0?0:type-1;
        WEAKSELF
        self.vcView.handler = ^(id result) {
            //点击结果
            NSIndexPath *indexPath = result;
            if (indexPath.section == 0) {
                //选项选择
                if (type == 0) {
                    weakSelf.sort_by = indexPath.row+1;
                    weakSelf.headView.dataArr[0] = dataArr[indexPath.row];
                } else if (type == 2) {
                    weakSelf.priceRange =  dataArr[indexPath.row];
                }
                weakSelf.tableView.showHeadRefreshControl = YES;
            }
            //头部恢复
            weakSelf.headView.currentIndex = -1;
            [weakSelf.headView.collectionView reloadData];
        };
        [self.vcView show];
    } else {
        [self.vcView hidden];
        //品牌导航
        WEAKSELF
        QLChooseBrandViewController *cbVC = [QLChooseBrandViewController new];
        cbVC.onlyShowBrand = YES;
        cbVC.callback = ^(QLBrandInfoModel * _Nullable brandModel, QLSeriesModel * _Nullable seriesModel, QLTypeInfoModel * _Nullable typeModel) {
            if (brandModel.brand_id.length != 0) {
                weakSelf.brand_id = brandModel.brand_id;
                weakSelf.tableView.showHeadRefreshControl = YES;
            }
        };
        [self.navigationController pushViewController:cbVC animated:YES];
    }
}
//全选
- (void)numBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        //全选
        self.chooseArr = [NSMutableArray arrayWithArray:self.dataArr];
    } else {
        //取消全选
        [self.chooseArr removeAllObjects];
    }
    [self.tableView reloadData];
}
//选择
- (void)chooseBtnClick:(UIButton *)sender {
    NSInteger row = sender.tag;
    QLCarInfoModel *model = self.dataArr[row];
    if ([self.chooseArr containsObject:model]) {
        [self.chooseArr removeObject:model];
    } else {
        [self.chooseArr addObject:model];
    }
    [self.tableView reloadData];
}
//确定
- (void)submitBtnClick {
    QLShareImgViewController *siVC = [QLShareImgViewController new];
    siVC.carInfoArr = self.chooseArr;
    siVC.type = 1;
    [self.navigationController pushViewController:siVC animated:YES];
}
#pragma mark- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLCarPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.chooseBtn.tag = indexPath.row;
    [cell.chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    QLCarInfoModel *model = self.dataArr[indexPath.row];
    cell.chooseBtn.selected = NO;
    for (QLCarInfoModel *chooseModel in self.chooseArr) {
        if ([model.car_id isEqualToString:chooseModel.car_id]) {
            cell.chooseBtn.selected = YES;
        }
    }
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QLCarPhotosCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.chooseBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [UIView new];
    //车数量
    QLBaseButton *numBtn = [QLBaseButton new];
    [numBtn setImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    [numBtn setImage:[UIImage imageNamed:@"success"] forState:UIControlStateSelected];
    NSString *numStr = [NSString stringWithFormat:@"  共%ld辆",(long)self.model.car_num.integerValue];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:numStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName: [UIColor colorWithHexString:@"999999"]}];
    [numBtn setAttributedTitle:string forState:UIControlStateNormal];
    [numBtn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    numBtn.selected = self.dataArr.count==self.chooseArr.count&&self.dataArr.count!=0?YES:NO;
    [headView addSubview:numBtn];
    [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.left.equalTo(headView).offset(16);
    }];
    
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 88;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}
#pragma mark- lazyLoading
- (QLVehicleSortView *)headView {
    if (!_headView) {
        _headView = [QLVehicleSortView new];
        _headView.delegate = self;
        _headView.showStatusItem = NO;
    }
    return _headView;
}
- (QLVehicleConditionsView *)vcView {
    if (!_vcView) {
        _vcView = [[QLVehicleConditionsView alloc]init];
        _vcView.offY = 44;
    }
    return _vcView;
}
- (QLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource= self;
        _tableView.extendDelegate = self;
        _tableView.showHeadRefreshControl = YES;
        _tableView.showFootRefreshControl = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"QLCarPhotosCell" bundle:nil] forCellReuseIdentifier:@"photoCell"];
        
    }
    return _tableView;
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)chooseArr {
    if (!_chooseArr) {
        _chooseArr = [NSMutableArray array];
    }
    return _chooseArr;
}

@end
