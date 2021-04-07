//
//  QLVehicleCertificateViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/25.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLVehicleCertificateViewController.h"
#import "QLVehicleSortView.h"
#import "QLVehicleConditionsView.h"
#import "QLShareImgViewController.h"
#import "QLVehicleCertificateCell.h"
#import "QLChooseBrandViewController.h"
#import "QLMyCarDetailViewController.h"

@interface QLVehicleCertificateViewController()<QLVehicleSortViewDelegate,UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) QLVehicleSortView *headView;
@property (nonatomic, strong) QLVehicleConditionsView *vcView;
@property (nonatomic, strong) QLBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@end
@implementation QLVehicleCertificateViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //刷新数据
//    self.tableView.showHeadRefreshControl = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.vcView hidden];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车辆牌证";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //头部
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    //tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom);
    }];
   
}
#pragma mrk- network
//列表请求
- (void)dataRequest {
   
}
#pragma mark- action

//类型变化
- (void)selectTypeBack:(NSInteger)type {
    if (type == 0||type == 2) {
        NSArray *dataArr = nil;
        NSIndexPath *selectIndexPath = nil;
        if (type == 0) {
            dataArr = @[@"智能排序",@"价格最低",@"价格最高",@"车龄最短",@"里程最少"];
            selectIndexPath = [NSIndexPath indexPathForRow:self.vcView.sort_by-1 inSection:0];
        } else if (type == 2) {
            dataArr = @[@"0-9999999",@"0-50000",@"50000-100000",@"100000-150000",@"150000-200000",@"200000-300000",@"300000-500000",@"500000-9999999"];
            selectIndexPath = [NSIndexPath indexPathForRow:[dataArr indexOfObject:self.vcView.priceRange] inSection:0];
        }
        self.vcView.selectIndexPath = selectIndexPath;
        self.vcView.type = type==0?0:type-1;
        WEAKSELF
        self.vcView.handler = ^(id result) {
            //点击结果
            NSIndexPath *indexPath = result;
            if (indexPath.section == 0) {
                //选项选择
                if (type == 0&&indexPath.row >= 0) {
                    weakSelf.vcView.sort_by = indexPath.row+1;
                    weakSelf.headView.dataArr[0] = dataArr[indexPath.row];
                } else if (type == 2&&indexPath.row >= 0) {
                    weakSelf.vcView.priceRange =  dataArr[indexPath.row];
                }
                [weakSelf reloadData];
            }
            //头部恢复
            weakSelf.headView.currentIndex = -1;
            [weakSelf.headView.collectionView reloadData];
        };
        [self.vcView show];
    } else if(type == 1) {
        [self.vcView hidden];
        //品牌导航
        WEAKSELF
        QLChooseBrandViewController *cbVC = [QLChooseBrandViewController new];
        cbVC.noShowModel = YES;
        cbVC.callback = ^(QLBrandInfoModel * _Nullable brandModel, QLSeriesModel * _Nullable seriesModel, QLTypeInfoModel * _Nullable typeModel) {
            if (brandModel.brand_id.length != 0) {
                weakSelf.vcView.brandModel = brandModel;
                [weakSelf reloadData];
            }
        };
        [self.navigationController pushViewController:cbVC animated:YES];
    }
}
//刷新
- (void)reloadData {
    
}
//刷新
- (void)rightItemClick {
    self.vcView.sort_by = 1;
    self.vcView.priceRange = @"0-9999999";
    self.vcView.brandModel = nil;
    self.headView.dataArr[0] = @"智能排序";
    [self.headView.collectionView reloadData];
//    self.tableView.showHeadRefreshControl = YES;
}
//车辆详情
- (void)detailBtnClick:(UIButton *)sender {
    QLMyCarDetailViewController *vcdVC = [QLMyCarDetailViewController new];
    [self.navigationController pushViewController:vcdVC animated:YES];
}
//分享证件
- (void)shareBtnClick:(UIButton *)sender {
    //去图片集合
    [self goShareImg:sender.tag];
}
//去图片集合
- (void)goShareImg:(NSInteger)row {
//    QLCarInfoModel *model = self.listArr[row];
    NSMutableArray *temArr = [NSMutableArray array];
//    for (QLCarBannerModel *attModel in model.att_list) {
//        if ([attModel.detecte_total_name isEqualToString:@"证件照片"]) {
//            [temArr addObject:attModel];
//        }
//    }
    QLShareImgViewController *siVC = [QLShareImgViewController new];
    siVC.imgsArr = temArr;
    siVC.type = 0;
    [self.navigationController pushViewController:siVC animated:YES];
}
#pragma mark- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLVehicleCertificateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"certificateCell" forIndexPath:indexPath];
    cell.detailBtn.tag = indexPath.row;
    cell.shareBtn.tag = indexPath.row;
    [cell.detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    cell.model = self.listArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self goShareImg:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
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
//        _tableView.showHeadRefreshControl = YES;
//        _tableView.showFootRefreshControl = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"QLVehicleCertificateCell" bundle:nil] forCellReuseIdentifier:@"certificateCell"];
        
    }
    return _tableView;
}
- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}
@end
