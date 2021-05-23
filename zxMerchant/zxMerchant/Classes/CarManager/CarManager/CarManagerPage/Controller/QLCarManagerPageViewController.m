//
//  QLCarManagerPageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/9/27.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarManagerPageViewController.h"
#import "QLCarManagerPageHeadView.h"
#import "QLVehicleConditionsView.h"
#import "QLChooseBrandViewController.h"
#import "QLCarSourceManagerViewController.h"
#import "QLEditTopCarViewController.h"
#import "QLDueProcessViewController.h"
#import "QLParamModel.h"
#import "QLVehicleWarnModel.h"
@interface QLCarManagerPageViewController ()<QLBaseSubViewControllerDelegate,QLBaseTableViewDelegate,QLChooseHeadViewDelegate,QLVehicleSortViewDelegate>
@property (nonatomic, strong) QLCarManagerPageHeadView *headView;
@property (nonatomic, strong) QLVehicleConditionsView *vcView;
@property (nonatomic, strong) QLParamModel *paramModel;
@property (nonatomic, strong) QLVehicleWarnModel *warnModel;

@property (nonatomic, copy) NSString *njString; //年检
@property (nonatomic, copy) NSString *qzxString; //强制险
@property (nonatomic, copy) NSString *allCarNum; //总数
@property (nonatomic, strong) NSMutableArray *allCarArray; //总数

@property (nonatomic, strong) QLCarSourceManagerViewController *csm1VC;
@property (nonatomic, strong) QLCarSourceManagerViewController *csm2VC;
@property (nonatomic, strong) QLCarSourceManagerViewController *csm3VC;
@end

@implementation QLCarManagerPageViewController

-(void)dataRequest
{
    [self requestForList:self.paramModel];
}

-(void)requestForList:(QLParamModel *)model
{
    NSString *pageNum = @"";
    if([model.local_state isEqualToString:@"1"])
    {
        //我的
        pageNum = [@(self.csm2VC.tableView.page) stringValue];
    }
    else if ([model.local_state isEqualToString:@"2"])
    {
        //合作
        pageNum = [@(self.csm3VC.tableView.page) stringValue];
    }
    else
    {
        //全部
        pageNum = [@(self.csm1VC.tableView.page) stringValue];
    }
    
    //我的车源=1 合作车源=2  传空是全部
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{
        @"operation_type":@"car_list",
        @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
        @"local_state":model.local_state,
        @"sort_by":model.sort_by,
        @"brand_id":model.brand_id,
        @"price_min":model.price_min,
        @"price_max":model.price_max,
        @"deal_state":model.deal_state,
        @"page_no":pageNum,
        @"page_size":@(listShowCount)
    } success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.allCarNum = [[response objectForKey:@"result_info"] objectForKey:@"car_num"];
        
        if([self.paramModel.local_state isEqualToString:@"1"])
        {
            //我的
            if (self.csm2VC.tableView.page == 1) {
                [self.allCarArray removeAllObjects];
            }
            NSArray *temArr = [[response objectForKey:@"result_info"] objectForKey:@"car_list"];
            [self.allCarArray addObjectsFromArray:temArr];
            //刷新设置
            [self.csm2VC.tableView.mj_header endRefreshing];
            if (temArr.count == listShowCount) {
                [self.csm2VC.tableView.mj_footer endRefreshing];
            } else {
                [self.csm2VC.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            //刷新
            [self.csm2VC uploadTableWithSourceArray:self.allCarArray];
        }
        else if ([self.paramModel.local_state isEqualToString:@"2"])
        {
            //合作
            if (self.csm3VC.tableView.page == 1) {
                [self.allCarArray removeAllObjects];
            }
            NSArray *temArr = [[response objectForKey:@"result_info"] objectForKey:@"car_list"];
            [self.allCarArray addObjectsFromArray:temArr];
            //刷新设置
            [self.csm3VC.tableView.mj_header endRefreshing];
            if (temArr.count == listShowCount) {
                [self.csm3VC.tableView.mj_footer endRefreshing];
            } else {
                [self.csm3VC.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            //刷新
            [self.csm3VC uploadTableWithSourceArray:self.allCarArray];
        }
        else
        {
            //全部
            if (self.csm1VC.tableView.page == 1) {
                [self.allCarArray removeAllObjects];
            }
            NSArray *temArr = [[response objectForKey:@"result_info"] objectForKey:@"car_list"];
            [self.allCarArray addObjectsFromArray:temArr];
            //刷新设置
            [self.csm1VC.tableView.mj_header endRefreshing];
            if (temArr.count == listShowCount) {
                [self.csm1VC.tableView.mj_footer endRefreshing];
            } else {
                [self.csm1VC.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            //刷新
            [self.csm1VC uploadTableWithSourceArray:self.allCarArray];
        }
        
        self.headView.numLB.text = [NSString stringWithFormat:@"共找到%lu辆车",(unsigned long)([self.allCarArray count] == 0?0:[self.allCarArray count])];

     

        
    } fail:^(NSError *error) {
        if([self.paramModel.local_state isEqualToString:@"1"])
        {
            //我的
            [self.csm2VC.tableView.mj_header endRefreshing];
            [self.csm2VC.tableView.mj_footer endRefreshing];
        }
        else if ([self.paramModel.local_state isEqualToString:@"2"])
        {
            //合作
            [self.csm3VC.tableView.mj_header endRefreshing];
            [self.csm3VC.tableView.mj_footer endRefreshing];
        }
        else
        {
            //全部
            [self.csm1VC.tableView.mj_header endRefreshing];
            [self.csm1VC.tableView.mj_footer endRefreshing];
        }

        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForOverDate
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:VehiclePath params:@{@"operation_type":@"get_merchant_car_warn",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.njString = [[[response objectForKey:@"result_info"] objectForKey:@"mot_warn"] stringValue];
        self.qzxString = [[[response objectForKey:@"result_info"] objectForKey:@"insure_warn"] stringValue];
        self.warnModel.mot_warn = self.njString?:@"0";
        self.warnModel.insure_warn = self.qzxString?:@"0";
        self.warnModel.assets_warn = @"0";
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.warnModel = [[QLVehicleWarnModel alloc] init];
    self.allCarArray = [[NSMutableArray alloc] initWithCapacity:0];

    //头部
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    //subView
    self.csm1VC = [QLCarSourceManagerViewController new];
    self.csm1VC.type = 0;
    
    self.csm2VC = [QLCarSourceManagerViewController new];
    self.csm2VC.type = 1;
    
    self.csm3VC = [QLCarSourceManagerViewController new];
    self.csm3VC.type = 2;
    
    self.subVCArr = @[self.csm1VC,self.csm2VC,self.csm3VC];
    self.needGestureRecognizer = YES;
    self.delegate = self;
    
    //配置默认值
    self.paramModel = [[QLParamModel alloc] init];
    self.paramModel.brand_id = @"";
    self.paramModel.deal_state = @"1";
    self.paramModel.local_state = @"0";
    self.paramModel.page_no = @"1";
    self.paramModel.page_size = @"20";
    self.paramModel.price_max = @"9999999";
    self.paramModel.price_min = @"1";
    self.paramModel.sort_by = @"1";
    
    [self requestForOverDate];
    
    self.csm1VC.tableView.extendDelegate = self;
    self.csm1VC.tableView.showHeadRefreshControl = YES;
    self.csm1VC.tableView.showFootRefreshControl = YES;
    
    self.csm2VC.tableView.extendDelegate = self;
    self.csm2VC.tableView.showHeadRefreshControl = YES;
    self.csm2VC.tableView.showFootRefreshControl = YES;
    
    self.csm3VC.tableView.extendDelegate = self;
    self.csm3VC.tableView.showHeadRefreshControl = YES;
    self.csm3VC.tableView.showFootRefreshControl = YES;
}
- (void)viewDidLayoutSubviews {
    [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = 160+(BottomOffset?44:20)+(self.headView.showResultView?48:0);
        make.height.mas_equalTo(height);
    }];
    
    for (UIViewController *vc in self.childViewControllers) {
        vc.view.frame = CGRectMake(0,CGRectGetMaxY(self.headView.frame), self.view.width, self.view.height-CGRectGetMaxY(self.headView.frame));
    }
}
#pragma mark - action
//头条车源
- (void)topCarBtnClick {
    QLEditTopCarViewController *etcVC = [QLEditTopCarViewController new];
    [self.navigationController pushViewController:etcVC animated:YES];
}
//筛选项点击
- (void)selectTypeBack:(NSInteger)type {
    if (type != 1) {
        NSArray *dataArr = nil;
        NSIndexPath *selectIndexPath = nil;
        if (type == 0) {
            dataArr = @[@"智能排序",@"价格最低",@"价格最高",@"车龄最短",@"里程最少"];
            selectIndexPath = [NSIndexPath indexPathForRow:self.vcView.sort_by-1 inSection:0];
        } else if (type == 2) {
            dataArr = @[@"0-9999999",@"0-50000",@"50000-100000",@"100000-150000",@"150000-200000",@"200000-300000",@"300000-500000",@"500000-9999999"];
            selectIndexPath = [NSIndexPath indexPathForRow:[dataArr indexOfObject:self.vcView.priceRange] inSection:0];
        } else {
            dataArr = @[@"在售",@"仓库中",@"已售"];
            NSInteger row = self.vcView.deal_state;
            self.vcView.warnModel = self.warnModel;
            selectIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
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
                    weakSelf.headView.sortView.dataArr[0] = dataArr[indexPath.row];
                    weakSelf.paramModel.sort_by = [NSString stringWithFormat:@"%ld",indexPath.row+1];
                } else if (type == 2&&indexPath.row >= 0) {
                    //价格
                    weakSelf.vcView.priceRange =  dataArr[indexPath.row];
                    NSString *price = dataArr[indexPath.row];
                    NSString *minPrice = [[price componentsSeparatedByString:@"-"] firstObject];
                    NSString *maxPrice = [[price componentsSeparatedByString:@"-"] lastObject];
                    weakSelf.paramModel.price_min = minPrice;
                    weakSelf.paramModel.price_max = maxPrice;

                } else if (type == 3&&indexPath.row >= 0) {
                    //在售
                    weakSelf.vcView.deal_state =  indexPath.row;
                    weakSelf.headView.sortView.dataArr[3] = dataArr[indexPath.row];
                    weakSelf.paramModel.deal_state = indexPath.row ==0?@"1":indexPath.row ==1?@"0":@"3";
                }
            } else if(indexPath.section == 1) {
                if (indexPath.row == 2) {
                    //库龄到期
                    if ([[QLToolsManager share].homePageModel getFun:ZXInventory] != nil) {
                       
                    }
                } else {
                    //年检 + 强制险
                    QLDueProcessViewController *dpVC = [QLDueProcessViewController new];
                    dpVC.viewType = indexPath.row;
                    [weakSelf.navigationController pushViewController:dpVC animated:YES];
                    
                }
            }
            //头部恢复
            weakSelf.headView.sortView.currentIndex = -1;
            [weakSelf.headView.sortView.collectionView reloadData];
            
            [weakSelf requestForList:weakSelf.paramModel];
        };
        [self.vcView show];
    } else {
        [self.vcView hidden];
        //品牌导航
        WEAKSELF
        QLChooseBrandViewController *cbVC = [QLChooseBrandViewController new];
        cbVC.noShowModel = YES;
        cbVC.callback = ^(QLBrandInfoModel * _Nullable brandModel, QLSeriesModel * _Nullable seriesModel, QLTypeInfoModel * _Nullable typeModel) {
            if (brandModel.brand_id.length != 0) {
                weakSelf.vcView.brandModel = brandModel;
                
                weakSelf.paramModel.brand_id = brandModel.brand_id;
                [weakSelf requestForList:weakSelf.paramModel];
            }
        };
        [self.navigationController pushViewController:cbVC animated:YES];
    }
}
//头部选择样式设置
- (void)chooseTitleStyle:(UIButton *)chooseBtn Index:(NSInteger)index {
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [chooseBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateSelected];
    
}
//头部选择点击
- (void)chooseSelect:(UIButton *)lastBtn CurrentBtn:(UIButton *)currentBtn Index:(NSInteger)index {
    lastBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    currentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
//    self.headView.showResultView = index==0?NO:YES;
    
    [self viewChangeAnimation:index];
    //我的车源=1 合作车源=2  传空是全部   此处要恢复默认
    if(index == 0)
    {
        self.paramModel.local_state = @"";
        self.paramModel.brand_id = @"";
        self.paramModel.deal_state = @"1";
        self.paramModel.page_no = @"1";
        self.paramModel.page_size = @"20";
        self.paramModel.price_max = @"9999999";
        self.paramModel.price_min = @"1";
        self.paramModel.sort_by = @"1";
    }
    else if (index == 1)
    {
        self.paramModel.local_state = @"1";
        self.paramModel.brand_id = @"";
        self.paramModel.deal_state = @"1";
        self.paramModel.page_no = @"1";
        self.paramModel.page_size = @"20";
        self.paramModel.price_max = @"9999999";
        self.paramModel.price_min = @"1";
        self.paramModel.sort_by = @"1";
    }
    else
    {
        self.paramModel.local_state = @"2";
        self.paramModel.brand_id = @"";
        self.paramModel.deal_state = @"1";
        self.paramModel.page_no = @"1";
        self.paramModel.page_size = @"20";
        self.paramModel.price_max = @"9999999";
        self.paramModel.price_min = @"1";
        self.paramModel.sort_by = @"1";
    }
    [self requestForList:self.paramModel];
    
}
//滑动切换
- (void)subViewChange:(UIViewController *)currentVC IndexPath:(NSInteger)index {
    self.headView.chooseView.selectedIndex = index;
}
#pragma mark - Lazy
- (QLCarManagerPageHeadView *)headView {
    if (!_headView) {
        _headView = [QLCarManagerPageHeadView new];
        
        _headView.chooseView.typeDelegate = self;
        
        _headView.sortView.showStatusItem = YES;
        _headView.sortView.delegate = self;
        
        [_headView.topBtn addTarget:self action:@selector(topCarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}
- (QLVehicleConditionsView *)vcView {
    if (!_vcView) {
        _vcView = [[QLVehicleConditionsView alloc]init];
        self.vcView.offY = self.headView.sortView.y-(BottomOffset?44:20);
    }
    return _vcView;
}
@end
