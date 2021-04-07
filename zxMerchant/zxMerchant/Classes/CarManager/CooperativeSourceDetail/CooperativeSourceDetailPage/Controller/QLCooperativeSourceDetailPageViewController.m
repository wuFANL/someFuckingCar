//
//  QLCooperativeSourceDetailPageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/18.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCooperativeSourceDetailPageViewController.h"
#import "QLCarCircleNaviView.h"
#import "QLCarDetailHeadView.h"
#import "QLCarDetailTextCell.h"
#import "QLCarDetailPriceCell.h"
#import "QLVehicleInstalmentCell.h"
#import "QLVehicleConfigCell.h"
#import "QLVehicleReportCell.h"
#import "QLVehicleDescCell.h"
#import "QLCarDetailSectionView.h"
#import "QLCooperativeSourceDetailBottomView.h"
#import "QLChatFloatView.h"
#import "QLCarDescViewController.h"

@interface QLCooperativeSourceDetailPageViewController ()<UITableViewDelegate,UITableViewDataSource,QLCarDetailHeadViewDelegate>
@property (nonatomic, strong) QLCarCircleNaviView *naviView;
@property (nonatomic, strong) QLCarDetailHeadView *headView;
@property (nonatomic, strong) QLCooperativeSourceDetailBottomView *bottomView;
@property (nonatomic, strong) QLChatFloatView *floatView;
@end

@implementation QLCooperativeSourceDetailPageViewController
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
        make.height.mas_equalTo(48);
    }];
    //tableView
    [self tableViewSet];
    //聊天消息提示
    [self.view addSubview:self.floatView];
    [self.floatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-15);
        make.width.mas_lessThanOrEqualTo(125);
        make.height.mas_equalTo(55);
    }];
    
}
#pragma mark - cell上按钮
//车辆描述
- (void)uploadControlClick {
    QLCarDescViewController *cdVC = [QLCarDescViewController new];
    [self.navigationController pushViewController:cdVC animated:YES];
}
//分区头更多按钮点击
- (void)headerAccBtnClick:(UIButton *)sender {
    
}
#pragma mark - 轮播图
//轮播图点击
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr Index:(NSInteger)index {
    
}
#pragma mark - 导航栏
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
    [self.tableView registerNib:[UINib nibWithNibName:@"QLVehicleInstalmentCell" bundle:nil] forCellReuseIdentifier:@"instalmentCell"];
    [self.tableView registerClass:[QLVehicleConfigCell class] forCellReuseIdentifier:@"configCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLVehicleReportCell" bundle:nil] forCellReuseIdentifier:@"reportCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLVehicleDescCell" bundle:nil] forCellReuseIdentifier:@"descCell"];
    
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
    return section==0||section==2?2:1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QLCarDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            
            return cell;
        } else {
            QLCarDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
            cell.contactBtn.hidden = NO;
            
            return cell;
        }
    } else if (indexPath.section == 1) {
        QLVehicleInstalmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instalmentCell" forIndexPath:indexPath];
        
        return cell;
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            QLVehicleConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"configCell" forIndexPath:indexPath];

            return cell;
        } else {
            QLVehicleReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell" forIndexPath:indexPath];
            
            return cell;
        }
        
    } else {
        QLVehicleDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell" forIndexPath:indexPath];
        [cell.uploadControl addTarget:self action:@selector(uploadControlClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2||section == 3) {
        QLCarDetailSectionView *sectionView = [QLCarDetailSectionView new];
        sectionView.titleLB.text = section==2?@"车辆信息":@"车辆描述";
        sectionView.moreBtn.tag = section;
        sectionView.moreBtn.hidden = section==2?NO:YES;
        [sectionView.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [sectionView.moreBtn addTarget:self action:@selector(headerAccBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return sectionView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 2||section == 3?45:0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return
    0.01;
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
        _headView.headBtn.hidden = NO;
        _headView.nameLB.hidden = NO;
        _headView.lookBtn.hidden = YES;
        _headView.delegate = self;
    }
    return _headView;
}
- (QLCooperativeSourceDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLCooperativeSourceDetailBottomView new];
        
    }
    return _bottomView;
}
- (QLChatFloatView *)floatView {
    if (!_floatView) {
        _floatView = [QLChatFloatView new];
    }
    return _floatView;
}
@end
