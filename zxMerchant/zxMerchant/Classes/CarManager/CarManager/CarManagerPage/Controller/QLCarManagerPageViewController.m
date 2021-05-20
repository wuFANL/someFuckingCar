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

@interface QLCarManagerPageViewController ()<QLBaseSubViewControllerDelegate,QLChooseHeadViewDelegate,QLVehicleSortViewDelegate>
@property (nonatomic, strong) QLCarManagerPageHeadView *headView;
@property (nonatomic, strong) QLVehicleConditionsView *vcView;
@property (nonatomic, strong) QLParamModel *paramModel;
@property (nonatomic, copy) NSString *njString; //年检
@property (nonatomic, copy) NSString *qzxString; //强制险
@property (nonatomic, copy) NSString *allCarNum; //总数
@property (nonatomic, strong) NSMutableArray *allCarArray; //总数

@property (nonatomic, strong) QLCarSourceManagerViewController *csm1VC;
@property (nonatomic, strong) QLCarSourceManagerViewController *csm2VC;
@property (nonatomic, strong) QLCarSourceManagerViewController *csm3VC;
@end

@implementation QLCarManagerPageViewController

-(void)requestForList:(QLParamModel *)model
{
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
        @"page_no":model.page_no,
        @"page_size":@"20",
    } success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.allCarNum = [[response objectForKey:@"result_info"] objectForKey:@"car_num"];
        
        [self.allCarArray removeAllObjects];
        [self.allCarArray addObjectsFromArray:[[response objectForKey:@"result_info"] objectForKey:@"car_list"]];
        
        if([self.paramModel.local_state isEqualToString:@"1"])
        {
            //我的
            [self.csm2VC uploadTableWithSourceArray:self.allCarArray];
        }
        else if ([self.paramModel.local_state isEqualToString:@"2"])
        {
            //合作
            [self.csm3VC uploadTableWithSourceArray:self.allCarArray];
        }
        else
        {
            //全部
            [self.csm1VC uploadTableWithSourceArray:self.allCarArray];
        }
        
        

    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForOverDate
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:VehiclePath params:@{@"operation_type":@"get_merchant_car_warn",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.njString = [[response objectForKey:@"result_info"] objectForKey:@"mot_warn"];
        self.qzxString = [[response objectForKey:@"result_info"] objectForKey:@"insure_warn"];

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
    
    [self requestForList:self.paramModel];
    [self requestForOverDate];
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
//刷新
- (void)reloadData {
    
}
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
                } else if (type == 2&&indexPath.row >= 0) {
                    weakSelf.vcView.priceRange =  dataArr[indexPath.row];
                } else if (type == 3&&indexPath.row >= 0) {
                    weakSelf.vcView.deal_state =  indexPath.row;
                    weakSelf.headView.sortView.dataArr[3] = dataArr[indexPath.row];
                }
                [weakSelf reloadData];
            } else if(indexPath.section == 1) {
                if (indexPath.row == 2) {
                    //库龄到期
                    if ([[QLToolsManager share].homePageModel getFun:ZXInventory] != nil) {
                       
                    }
                } else {
                    QLDueProcessViewController *dpVC = [QLDueProcessViewController new];
                    dpVC.viewType = indexPath.row;
                    [weakSelf.navigationController pushViewController:dpVC animated:YES];
                    
                }
            }
            //头部恢复
            weakSelf.headView.sortView.currentIndex = -1;
            [weakSelf.headView.sortView.collectionView reloadData];
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
                [weakSelf reloadData];
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
        _headView.resultView.itemArr = @[@"本田",@"20万以上"];
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
