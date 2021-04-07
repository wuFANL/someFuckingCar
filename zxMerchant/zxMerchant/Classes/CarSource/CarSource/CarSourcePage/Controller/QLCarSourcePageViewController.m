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
#import "QLChooseBrandViewController.h"
#import "QLTopCarSourceViewController.h"
#import "QLAllCarSourceViewController.h"
#import "QLAdvancedScreeningViewController.h"

@interface QLCarSourcePageViewController ()<QLBaseSubViewControllerDelegate,QLBannerViewDelegate,QLChooseHeadViewDelegate,QLVehicleSortViewDelegate>
@property (nonatomic, strong) QLCarSourceNaviView *naviView;
@property (nonatomic, strong) QLCarSourceHeadView *headView;
@property (nonatomic, strong) QLVehicleConditionsView *vcView;

@end

@implementation QLCarSourcePageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
   
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
    
    //subView
    QLTopCarSourceViewController *tcsVC = [QLTopCarSourceViewController new];
    QLAllCarSourceViewController *acsVC = [QLAllCarSourceViewController new];
    self.subVCArr = @[tcsVC,acsVC];
    self.needGestureRecognizer = YES;
    self.delegate = self;
}
- (void)viewDidLayoutSubviews {
    [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = 140+(BottomOffset?44:20)+(self.headView.showResultView?48:0);
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
//筛选项点击
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
                    weakSelf.headView.conditionView.dataArr[0] = dataArr[indexPath.row];
                } else if (type == 2&&indexPath.row >= 0) {
                    weakSelf.vcView.priceRange =  dataArr[indexPath.row];
                }
                [weakSelf reloadData];
            }
            //头部恢复
            weakSelf.headView.conditionView.currentIndex = -1;
            [weakSelf.headView.conditionView.collectionView reloadData];
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
    } else {
        [self.vcView hidden];
        //筛选
        QLAdvancedScreeningViewController *asVC = [QLAdvancedScreeningViewController new];
        asVC.showCity = NO;
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
    self.headView.showResultView = index==0?NO:YES;
    
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
#pragma mark - Lazy
- (QLCarSourceNaviView *)naviView {
    if(!_naviView) {
        _naviView = [QLCarSourceNaviView new];
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
        
        _headView.conditionResultView.itemArr = @[@"本田",@"20万以上"];
    }
    return _headView;
}
- (QLVehicleConditionsView *)vcView {
    if (!_vcView) {
        _vcView = [[QLVehicleConditionsView alloc]init];
        self.vcView.offY = self.headView.conditionView.y-(BottomOffset?44:20);
    }
    return _vcView;
}
@end
