//
//  QLCarSourceDetailViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/26.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarSourceDetailViewController.h"
#import "QLCarCircleNaviView.h"
#import "QLCarDetailHeadView.h"
#import "QLCarDetailSectionView.h"
#import "QLCarDetailTextCell.h"
#import "QLCarDetailPriceCell.h"
#import "QLVehicleConfigCell.h"
#import "QLVehicleDescCell.h"
#import "QLVehicleReportCell.h"
#import "QLTableImgCell.h"
#import "QLCarImgShowCell.h"
#import "QLFunBottomView.h"
#import "QLCarDescViewController.h"

@interface QLCarSourceDetailViewController ()<UITableViewDelegate,UITableViewDataSource,QLCarDetailHeadViewDelegate>
@property (nonatomic, strong) QLCarCircleNaviView *naviView;
@property (nonatomic, strong) QLCarDetailHeadView *headView;
@property (nonatomic, strong) QLFunBottomView *bottomView;
/** 车辆信息*/
@property (nonatomic, strong) NSDictionary *carData;
@end

@implementation QLCarSourceDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44+(BottomOffset?44:20));
    }];
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(50);
    }];
    //tableView
    [self tableViewSet];
}

#pragma mark -- 数据更新方法
- (void)updateVcWithData:(NSDictionary *)dic {
    // 请求车辆信息
    NSDictionary *paraDic = @{
        @"operation_type":@"car/info",
        @"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id?[QLUserInfoModel getLocalInfo].account.account_id:@"",
        @"account_id":[dic objectForKey:@"account_id"],
        @"car_id":[dic objectForKey:@"car_id"]
    };
    
    WEAKSELF
    [QLNetworkingManager postWithUrl:BusinessPath params:paraDic success:^(id response) {
        [weakSelf parseDataWithResponse:response];
        // 刷新背景图
        [weakSelf parseAndRefreshHeaderImage:response];
        // 刷新主数据
        [weakSelf.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)parseDataWithResponse:(NSDictionary *)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *reslutInfo = [response objectForKey:@"result_info"];
        if ([reslutInfo isKindOfClass:[NSDictionary class]]) {
            self.carData = reslutInfo;
        }
    }
}

// 解析并刷新汽车背景图
- (void)parseAndRefreshHeaderImage:(NSDictionary *)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *reslutInfo = [response objectForKey:@"result_info"];
        if ([reslutInfo isKindOfClass:[NSDictionary class]]) {
            NSString *headerUrl = [NSString stringWithFormat:@"%@",[[reslutInfo objectForKey:@"car_info"] objectForKey:@"car_img"]];
            self.headView.bannerArr = @[headerUrl];
            //self.headView.headBtn.backgroundColor =[UIColor redColor];
        }
    }
}

#pragma mark - action
//谈价格
- (void)priceBtnClick {
    
}
//加入车库
- (void)joinBtnClick {
    
}
//更多图片
- (void)moreImgBtnClick {
    
}
//检测报告
- (void)checkReport {
    
}
//车辆描述
- (void)uploadControlClick {
    QLCarDescViewController *cdVC = [QLCarDescViewController new];
    [self.navigationController pushViewController:cdVC animated:YES];
}
//分区头更多按钮点击
- (void)headerAccBtnClick:(UIButton *)sender {
    
}
//分区尾更多按钮点击
- (void)footerAccBtnClick:(UIButton *)sender {
    
}
//轮播图点击
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr Index:(NSInteger)index {
    
}
//分享
- (void)funBtnClick {
    
}
//返回
- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarDetailTextCell" bundle:nil] forCellReuseIdentifier:@"titleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarDetailPriceCell" bundle:nil] forCellReuseIdentifier:@"priceCell"];
    [self.tableView registerClass:[QLVehicleConfigCell class] forCellReuseIdentifier:@"configCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLVehicleDescCell" bundle:nil] forCellReuseIdentifier:@"descCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLVehicleReportCell" bundle:nil] forCellReuseIdentifier:@"reportCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLTableImgCell" bundle:nil] forCellReuseIdentifier:@"imgCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarImgShowCell" bundle:nil] forCellReuseIdentifier:@"carImgCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    //tableHeaderView
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 250)];
    [tableHeaderView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableHeaderView);
    }];
    self.tableView.tableHeaderView = tableHeaderView;
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?2:section==3?4:1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 车辆名称
            QLCarDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            if (self.carData) {
                cell.titleLB.text = [NSString stringWithFormat:@"%@",[[self.carData objectForKey:@"car_info"] objectForKey:@"model"]];
            }
            return cell;
        } else {
            // 车辆价格
            QLCarDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
            [cell updateWithDic:self.carData];
            return cell;
        }
    } else if (indexPath.section == 1) {
        QLVehicleConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"configCell" forIndexPath:indexPath];

        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            QLVehicleDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell" forIndexPath:indexPath];
            [cell.uploadControl addTarget:self action:@selector(uploadControlClick) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        } else {
            QLVehicleReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell" forIndexPath:indexPath];
            [cell.accBtn addTarget:self action:@selector(checkReport) forControlEvents:UIControlEventTouchUpInside];
            cell.accBtn.selected = YES;
            cell.detailLB.text = @"查看详细检测报告";
            return cell;
        }
    } else {
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            QLCarImgShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carImgCell" forIndexPath:indexPath];
            [cell.checkReportBtn setTitle:@"查看更多" forState:UIControlStateNormal];
            [cell.checkReportBtn addTarget:self action:@selector(moreImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } else {
            QLTableImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imgCell" forIndexPath:indexPath];
            NSString *imgUrl = @"";
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    cell.imgHeight.constant = (self.view.width-30)*(image.size.height/image.size.width);
                }
            }];
            return cell;
        }
    }
    
    

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        QLCarDetailSectionView *sectionView = [QLCarDetailSectionView new];
        sectionView.titleLB.text = section==1?@"车辆信息":section==2?@"车辆描述":@"车辆图片";
        sectionView.moreBtn.tag = section;
        sectionView.moreBtn.hidden = section==1?NO:YES;
        [sectionView.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [sectionView.moreBtn addTarget:self action:@selector(headerAccBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return sectionView;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        QLCarDetailSectionView *sectionView = [QLCarDetailSectionView new];
        sectionView.titleLB.text = @"";
        sectionView.collectBtn.hidden = NO;
        sectionView.moreBtn.tag = section;
        sectionView.moreBtn.hidden = NO;
        [sectionView.moreBtn setTitle:@"TA的车源" forState:UIControlStateNormal];
        [sectionView.moreBtn addTarget:self action:@selector(footerAccBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return sectionView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section != 0?45:0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2?45:0.01;
}
#pragma mark - Lazy
- (QLCarCircleNaviView *)naviView {
    if(!_naviView) {
        _naviView = [QLCarCircleNaviView new];
        [_naviView.funBtn setImage:[UIImage imageNamed:@"share_white"] forState:UIControlStateNormal];
        [_naviView.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_naviView.funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviView;
}
- (QLCarDetailHeadView *)headView {
    if(!_headView) {
        _headView = [[QLCarDetailHeadView alloc] init];
        _headView.headBtn.hidden = YES;
        _headView.nameLB.hidden = YES;
        _headView.delegate = self;
    }
    return _headView;
}
- (QLFunBottomView *)bottomView {
    if(!_bottomView) {
        _bottomView = [QLFunBottomView new];
        [_bottomView.aBtn setTitle:@"加入我的车库" forState:UIControlStateNormal];
        [_bottomView.bBtn setTitle:@"谈谈价格" forState:UIControlStateNormal];
        [_bottomView.aBtn addTarget:self action:@selector(joinBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.bBtn addTarget:self action:@selector(priceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
@end
