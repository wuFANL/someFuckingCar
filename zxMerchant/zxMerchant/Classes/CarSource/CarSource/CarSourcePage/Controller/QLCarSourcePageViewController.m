//
//  QLCarSourcePageViewController.m
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/20.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLCarSourcePageViewController.h"
#import "QLCarSourceNaviView.h"
#import "QLCarSourceHeadView.h"
#import "QLVehicleConditionsView.h"
#import "QLHomeSearchViewController.h"
#import "QLChooseBrandViewController.h"
#import "QLTopCarSourceViewController.h"
#import "QLAllCarSourceViewController.h"
#import "QLAdvancedScreeningViewController.h"
#import "CitySelectViewController.h"

#define typeStringArr @[@"智能排序",@"价格最低",@"价格最高",@"车龄最短",@"里程最少"]
#define priceStringArr @[@"不限价格",@"5万以内",@"5万-10万",@"10万-15万",@"15万-20万",@"20万以上"]
//NSArray *
@interface QLCarSourcePageViewController ()<QLBaseSubViewControllerDelegate,QLBaseSearchBarDelegate,QLBannerViewDelegate,QLChooseHeadViewDelegate,QLVehicleSortViewDelegate>
@property (nonatomic, strong) QLCarSourceNaviView *naviView;
@property (nonatomic, strong) QLCarSourceHeadView *headView;
@property (nonatomic, strong) QLVehicleConditionsView *vcView;
@property (nonatomic, strong) NSMutableDictionary *conditionDic;
//筛选
@property (nonatomic, strong) NSMutableDictionary *conditionSelect;
/** 城市编码*/
@property (nonatomic, strong) NSString *cityCode;
@end

@implementation QLCarSourcePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.vcView hidden];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //头部
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    //导航栏
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44+(BottomOffset?44:20));
    }];
    
    WEAKSELF
    //subView
    QLTopCarSourceViewController *tcsVC = [QLTopCarSourceViewController new];
    tcsVC.refreshBlock = ^(NSUInteger page) {
        [weakSelf topCarSourceReloadData];
    };
    QLAllCarSourceViewController *acsVC = [QLAllCarSourceViewController new];
    acsVC.refreshBlock = ^(NSUInteger currentPage) {
        [weakSelf allCarSourceReloadData];
    };
    self.subVCArr = @[tcsVC,acsVC];
    self.needGestureRecognizer = YES;
    self.delegate = self;
    [self reloadSubVcData];
}

- (void)viewDidLayoutSubviews {
    [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = 140+(BottomOffset?44:20)+(self.headView.showResultView?48:0);
        make.height.mas_equalTo(height);
    }];
    
    [self.headView.bannerView setNeedsLayout];
    [self.headView.bannerView layoutIfNeeded];
    
    for (UIViewController *vc in self.childViewControllers) {
        vc.view.frame = CGRectMake(0,CGRectGetMaxY(self.headView.frame), self.view.width, self.view.height-CGRectGetMaxY(self.headView.frame));
    }
}

- (void)reloadSubVcData{
    [self allCarSourceReloadData];
    [self topCarSourceReloadData];
    // 检查是否有筛选项
    [self checkIsHasSelectItem];
}

- (void)checkIsHasSelectItem{
    BOOL hasSelect = self.conditionDic.count ==0?NO:YES;
    if (hasSelect) {
        // show
        self.headView.showResultView = YES;
        self.headView.conditionResultView.itemArr = self.conditionDic.allValues;
    } else {
        // hide
        self.headView.showResultView = NO;
    }
}

#pragma mark - action
//刷新
- (NSDictionary *)currrentPara {
    // condition无法提供数据 只能展示
    
    NSUInteger type = self.vcView.sort_by;
    NSString *brand_id = self.vcView.brandModel.brand_id?self.vcView.brandModel.brand_id:@"";
    NSString *price = self.vcView.priceRange;
    
    NSString *min_price = @"1";
    NSString *max_price = @"9999999";
    if (price && [price containsString:@"-"]) {
        // 根据 - 分成两段
        min_price = [price componentsSeparatedByString:@"-"].firstObject;
        max_price = [price componentsSeparatedByString:@"-"].lastObject;
    }
    
    NSString * cityCode = [QLUserInfoModel getLocalInfo].account.last_city_code?[QLUserInfoModel getLocalInfo].account.last_city_code:@"0";
    // 获取新的cityCode
    if (self.cityCode && self.cityCode.length >0) {
        cityCode = self.cityCode;
    }
    
    NSMutableDictionary *dic = @{
        @"sort_by":[NSString stringWithFormat:@"%lu",type],
        @"page_size":@(listShowCount),
        @"min_price":min_price,
        @"max_price":max_price,
        @"city_code":cityCode,
    }.mutableCopy;
    NSString *series_id = self.vcView.seriesModel.series_id;
    if (series_id && [series_id isKindOfClass:[NSString class]] && ![series_id isEqualToString:@"0"]) {
        [dic setValue:series_id forKey:@"series_id"];
    }
    if (brand_id && ![brand_id isEqualToString:@""]) {
        [dic setValue:brand_id forKey:@"brand_id"];
    }
    
    return dic.copy;
}

// 全部车源刷新
- (void)allCarSourceReloadData{
    
    QLAllCarSourceViewController*vc_all = (QLAllCarSourceViewController *)self.subVCArr.lastObject;
    NSInteger allPage = vc_all.tableView.page;
    
    NSMutableDictionary *conditionDic = [[self currrentPara] mutableCopy];
    [conditionDic setObject:@"query_all_car_list" forKey:@"operation_type"];
    [conditionDic setObject:@(allPage + 1) forKey:@"page_no"];
    [QLNetworkingManager postWithUrl:BusinessPath params:conditionDic success:^(id response) {
        NSDictionary* resultDic = response;
        // 停止刷新动作
        [vc_all endRefresh];
        if (resultDic && [resultDic.allKeys containsObject:@"result_info"]) {
            NSDictionary * infoDic = [resultDic objectForKey:@"result_info"];
            if (infoDic && [infoDic.allKeys containsObject:@"car_list"]) {
                NSArray *carArray = [infoDic objectForKey:@"car_list"];
                if ([carArray isKindOfClass:[NSArray class]] && carArray.count > 0) {
                    // 1. page数增加
                    vc_all.tableView.page ++;
                    // 2. 对数据源拼接
                    [vc_all.dataArray addObjectsFromArray:carArray];
                    // 刷新数据
                }
                [vc_all.tableView reloadData];
            }
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
        [vc_all endRefresh];
    }];
}

// 刷新头部车源
- (void)topCarSourceReloadData {
    
    QLTopCarSourceViewController*vc_top = (QLTopCarSourceViewController *)self.subVCArr.firstObject;
    NSInteger topPage = vc_top.tableView.page;
    NSMutableDictionary *conditionDic = [[self currrentPara] mutableCopy];
    [conditionDic setObject:@"query_top_car_list" forKey:@"operation_type"];
    [conditionDic setObject:@(topPage + 1) forKey:@"page_no"];
    
    [QLNetworkingManager postWithUrl:BusinessPath params:conditionDic success:^(id response) {
        // 停止刷新动作
        NSDictionary* resultDic = response;
        // 停止刷新动作
        [vc_top endRefresh];
        if (resultDic && [resultDic.allKeys containsObject:@"result_info"]) {
            NSDictionary * infoDic = [resultDic objectForKey:@"result_info"];
            if (infoDic && [infoDic.allKeys containsObject:@"car_list"]) {
                NSArray *carArray = [infoDic objectForKey:@"car_list"];
                if ([carArray isKindOfClass:[NSArray class]] && carArray.count > 0) {
                    // 1. page数增加
                    vc_top.tableView.page ++;
                    // 2. 对数据源拼接
                    [vc_top.dataArray addObjectsFromArray:carArray];
                    // 刷新数据
                    
                }
                [vc_top.tableView reloadData];
            }
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
        [vc_top endRefresh];
    }];
    
}

//筛选项点击
- (void)selectTypeBack:(NSInteger)type {
    
    if (type == 0||type == 2) {
        CGFloat conditionResultViewY = CGRectGetMaxY(self.headView.conditionResultView.frame)-(BottomOffset?88:64);
        if (conditionResultViewY != self.vcView.offY) {
            self.vcView.offY = conditionResultViewY;
        }
        
        NSArray * __block dataArr = nil;
        NSIndexPath *selectIndexPath = nil;
        if (type == 0) {
            dataArr = typeStringArr;
            selectIndexPath = [NSIndexPath indexPathForRow:self.vcView.sort_by-1 inSection:0];
        } else if (type == 2) {
            dataArr = @[@"0-9999999",@"0-50000",@"50000-100000",@"100000-150000",@"150000-200000",@"200000-300000",@"300000-500000",@"500000-9999999"];
            selectIndexPath = [NSIndexPath indexPathForRow:[dataArr indexOfObject:self.vcView.priceRange] inSection:0];
        }
        self.vcView.type = type==0?0:type-1;
        self.vcView.currentIndexPath = selectIndexPath;
        
        WEAKSELF
        self.vcView.handler = ^(id result) {
            //点击结果
            NSIndexPath *indexPath = result;
            if (indexPath.section == 0) {
                //选项选择
                if (type == 0&&indexPath.row >= 0) {  // 排序种类
                    weakSelf.vcView.sort_by = indexPath.row+1;
                    NSString *sort_by_Str = dataArr[indexPath.row];
                    weakSelf.headView.conditionView.dataArr[0] = sort_by_Str;
                    [weakSelf.conditionDic setObject:sort_by_Str forKey:@"sort_by"];
                    
                } else if (type == 2&&indexPath.row >= 0) { // 价格
                    
                    weakSelf.vcView.priceRange =  dataArr[indexPath.row];
                    
                    [weakSelf.conditionDic setObject:weakSelf.vcView.priceRangeArr[indexPath.row] forKey:@"priceRange"];
                }
            }
            //头部恢复
            weakSelf.headView.conditionView.currentIndex = -1;
            [weakSelf.headView.conditionView.collectionView reloadData];
            
            QLAllCarSourceViewController*vc_all = (QLAllCarSourceViewController *)weakSelf.subVCArr.lastObject;
            vc_all.tableView.page = 0;
            [vc_all.dataArray removeAllObjects];
            QLTopCarSourceViewController*vc_top = (QLTopCarSourceViewController *)weakSelf.subVCArr.firstObject;
            vc_top.tableView.page = 0;
            [vc_top.dataArray removeAllObjects];
            [weakSelf reloadSubVcData];
        };
        [self.vcView show];
    } else if(type == 1) {
        self.headView.conditionView.currentIndex = -1;
        [self.vcView hidden];
        //品牌导航
        WEAKSELF
        QLChooseBrandViewController *cbVC = [QLChooseBrandViewController new];
        cbVC.noShowModel = YES;
        cbVC.brand_id = self.vcView.brandModel.brand_id;
        cbVC.series_id = self.vcView.seriesModel.series_id;
        
        cbVC.callback = ^(QLBrandInfoModel * _Nullable brandModel, QLSeriesModel * _Nullable seriesModel, QLTypeInfoModel * _Nullable typeModel) {
            //            品牌导航数据刷新
            weakSelf.vcView.brandModel = brandModel;
            weakSelf.vcView.seriesModel = seriesModel;
            NSString *carName = [NSString stringWithFormat:@"%@%@",brandModel.brand_name,seriesModel.series_name];
            if ([seriesModel.series_id isKindOfClass:[NSString class]] && [seriesModel.series_id isEqualToString:@"0"]) {
                carName = [NSString stringWithFormat:@"%@",seriesModel.series_name];
            }
            
            
            [weakSelf.conditionDic setObject:carName forKey:@"carName"];
            
            // 页数重置
            QLAllCarSourceViewController*vc_all = (QLAllCarSourceViewController *)weakSelf.subVCArr.lastObject;
            vc_all.tableView.page = 0;
            [vc_all.dataArray removeAllObjects];
            QLTopCarSourceViewController*vc_top = (QLTopCarSourceViewController *)weakSelf.subVCArr.firstObject;
            vc_top.tableView.page = 0;
            [vc_top.dataArray removeAllObjects];
            [weakSelf reloadSubVcData];
            
        };
        [self.navigationController pushViewController:cbVC animated:YES];
    } else {
        self.headView.conditionView.currentIndex = -1;
        [self.vcView hidden];
        //筛选
        QLAdvancedScreeningViewController *asVC = [QLAdvancedScreeningViewController new];
        asVC.showCity = NO;
        asVC.isSubscription = YES;
        WEAKSELF
        asVC.resultHandler = ^(id result, NSError *error) {
            if (!error&& result) {
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)result;
                    NSMutableDictionary *tempDic = weakSelf.conditionDic.mutableCopy;
                    
                    for (NSString *key in weakSelf.conditionSelect.allKeys) {
                        for (NSString *key2 in tempDic.allKeys) {
                            if ([key isEqualToString:key2]) {
                                [self.conditionDic removeObjectForKey:key2];
                            }
                        }
                    }
                    weakSelf.conditionSelect = dic.mutableCopy;
                    for (NSString *key in weakSelf.conditionSelect.allKeys) {
                        [weakSelf.conditionDic setValue:self.conditionSelect[key] forKey:key];
                        
                    }
                    [weakSelf clearConditionToRefresh];
                }
            }
        };
        [self.navigationController pushViewController:asVC animated:YES];
    }
}
//类型标题设置
- (void)chooseTitleStyle:(UIButton *)chooseBtn Index:(NSInteger)index {
    NSString *title = self.headView.typeView.typeArr[index];
    [chooseBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [chooseBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
    [chooseBtn setTitle:title forState:UIControlStateNormal];
}
//类型标题点击
- (void)chooseSelect:(UIButton *)lastBtn CurrentBtn:(UIButton *)currentBtn Index:(NSInteger)index {
    //    self.headView.showResultView = index==0?NO:YES;
    [self viewChangeAnimation:index];
}
//轮播图
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn {
    
    [imageBtn setBackgroundImage:[UIImage imageNamed:imageArr[index]] forState:UIControlStateNormal];
}
//滑动切换
- (void)subViewChange:(UIViewController *)currentVC IndexPath:(NSInteger)index {
    self.headView.typeView.selectedIndex = index;
    
}
//搜索点击
- (void)noEditClick {
    QLHomeSearchViewController *hsVC = [QLHomeSearchViewController new];
    hsVC.searchType = SearchBrand;
    [self.navigationController pushViewController:hsVC animated:YES];
}

- (void)addressTouched {
    // 弹出地址组件
    CitySelectViewController* vc = [CitySelectViewController new];
    WEAKSELF
    vc.selectBlock = ^(NSDictionary * _Nonnull fatherDic, NSDictionary * _Nonnull subDic, NSString * _Nonnull adcode) {
        // 更新
        NSString *cityNam = EncodeStringFromDic(subDic, @"region_name");
        [weakSelf.naviView.addressBtn setTitle:cityNam forState:UIControlStateNormal];
        weakSelf.cityCode = adcode;
        QLAllCarSourceViewController*vc_all = (QLAllCarSourceViewController *)weakSelf.subVCArr.lastObject;
        vc_all.tableView.page = 0;
        [vc_all.dataArray removeAllObjects];
        QLTopCarSourceViewController*vc_top = (QLTopCarSourceViewController *)weakSelf.subVCArr.firstObject;
        vc_top.tableView.page = 0;
        [vc_top.dataArray removeAllObjects];
        [weakSelf reloadSubVcData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wantTouched {
    QLAdvancedScreeningViewController *asVC = [QLAdvancedScreeningViewController new];
    asVC.showCity = NO;
    asVC.isSubscription = YES;
    [self.navigationController pushViewController:asVC animated:YES];
}
#pragma mark - Lazy
- (QLCarSourceNaviView *)naviView {
    if(!_naviView) {
        _naviView = [QLCarSourceNaviView new];
        _naviView.searchBar.extenDelegate = self;
        [_naviView.addressBtn addTarget:self action:@selector(addressTouched) forControlEvents:UIControlEventTouchUpInside];
        [_naviView.wantBtn addTarget:self action:@selector(wantTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviView;
}
- (QLCarSourceHeadView *)headView {
    if (!_headView) {
        _headView = [QLCarSourceHeadView new];
        _headView.bannerView.delegate = self;
        _headView.bannerView.imagesArr = @[@"carSourceBj"];
        
        _headView.typeView.typeDelegate = self;
        _headView.typeView.typeArr = @[@"头条车源",@"全部"];
        
        _headView.conditionView.showScreenItem = YES;
        _headView.conditionView.delegate = self;
        WEAKSELF
        _headView.conditionResultView.dataHandler = ^(id result) {
            NSArray *dataArr = result;
            //数据变化回调
            NSInteger diffIndex = -1;
            for (NSString *value in weakSelf.conditionDic.allValues) {
                if (![dataArr containsObject:value]) {
                    //找到了要删除的值
                    diffIndex = [weakSelf.conditionDic.allValues indexOfObject:value];
                    
                    // 这里需要判断下删除的是哪个值 是排序种类 还是品牌 还是价格
                    if ([typeStringArr containsObject:value]) { // 排序
                        weakSelf.vcView.sort_by = 1;
                    } else if ([priceStringArr containsObject:value]) { // 价格
                        weakSelf.vcView.priceRange = @"0-9999999";
                    } else {
                        // 品牌
                        weakSelf.vcView.brandModel.brand_id = @"";
                    }
                    
                }
            }
            [weakSelf.conditionDic removeObjectAtIndex:diffIndex];
            // 检查是否有筛选项
            [weakSelf checkIsHasSelectItem];
            [weakSelf clearSelect];
            [weakSelf clearConditionToRefresh];
            
        };
    }
    return _headView;
}
- (void)clearConditionToRefresh{
    
    QLAllCarSourceViewController*vc_all = (QLAllCarSourceViewController *)self.subVCArr.lastObject;
    vc_all.tableView.page = 0;
    [vc_all.dataArray removeAllObjects];
    QLTopCarSourceViewController*vc_top = (QLTopCarSourceViewController *)self.subVCArr.firstObject;
    vc_top.tableView.page = 0;
    [vc_top.dataArray removeAllObjects];
    [self reloadSubVcData];
    
}


- (void )clearSelect{
    self.vcView.brandModel = nil;
    self.vcView.seriesModel = nil;
}


- (QLVehicleConditionsView *)vcView {
    if (!_vcView) {
        _vcView = [[QLVehicleConditionsView alloc]init];
    }
    return _vcView;
}
- (NSMutableDictionary *)conditionDic {
    if (!_conditionDic) {
        _conditionDic = [NSMutableDictionary dictionary];
    }
    return _conditionDic;
}
- (NSMutableDictionary *)conditionSelect {
    if (!_conditionSelect) {
        _conditionSelect = [NSMutableDictionary dictionary];
    }
    return _conditionSelect;
}
@end
