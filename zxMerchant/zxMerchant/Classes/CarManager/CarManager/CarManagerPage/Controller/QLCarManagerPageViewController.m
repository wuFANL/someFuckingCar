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

@interface QLCarManagerPageViewController ()<QLBaseSubViewControllerDelegate,QLChooseHeadViewDelegate,QLVehicleSortViewDelegate>
@property (nonatomic, strong) QLCarManagerPageHeadView *headView;
@property (nonatomic, strong) QLVehicleConditionsView *vcView;

@end

@implementation QLCarManagerPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //头部
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    //subView
    QLCarSourceManagerViewController *csm1VC = [QLCarSourceManagerViewController new];
    csm1VC.type = 0;
    
    QLCarSourceManagerViewController *csm2VC = [QLCarSourceManagerViewController new];
    csm2VC.type = 1;
    
    QLCarSourceManagerViewController *csm3VC = [QLCarSourceManagerViewController new];
    csm3VC.type = 2;
    
    self.subVCArr = @[csm1VC,csm2VC,csm3VC];
    self.needGestureRecognizer = YES;
    self.delegate = self;
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
    
    self.headView.showResultView = index==0?NO:YES;
    
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
