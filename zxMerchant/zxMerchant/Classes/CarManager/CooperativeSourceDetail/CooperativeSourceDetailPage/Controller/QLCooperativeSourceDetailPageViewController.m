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
#import "QLChatListPageViewController.h"
#import "QLContactsStoreViewController.h"

@interface QLCooperativeSourceDetailPageViewController ()<UITableViewDelegate,UITableViewDataSource,QLCarDetailHeadViewDelegate>
@property (nonatomic, strong) QLCarCircleNaviView *naviView;
@property (nonatomic, strong) QLCarDetailHeadView *headView;
@property (nonatomic, strong) QLCooperativeSourceDetailBottomView *bottomView;
@property (nonatomic, strong) QLChatFloatView *floatView;
@property (nonatomic, copy) NSDictionary *allSourceDic;

@property (nonatomic, strong) NSMutableDictionary *sourceDic;
@end

@implementation QLCooperativeSourceDetailPageViewController

-(id)initWithSourceDic:(NSDictionary *)dic {
    self = [super init];
    if(self) {
        self.sourceDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [self.sourceDic addEntriesFromDictionary:dic];
    }
    return self;
}

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
    
    [self.view addSubview:self.bottomView];
    //底部  帮卖不展示
    if([[self.sourceDic objectForKey:@"local_state"] intValue] == 2)
    {
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
            make.height.mas_equalTo(48);
        }];
    }
    else
    {
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(50);
            make.height.mas_equalTo(48);
        }];
    }
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
    
    [self requestForMsgList];
    [self requestForCarPicList];
}

-(void)requestForMsgList
{
    NSString *fromUserID = [self.sourceDic objectForKey:@"account_id"];
    NSString *carid = [self.sourceDic objectForKey:@"id"];
    NSString *buscarid = [self.sourceDic objectForKey:@"business_car_id"];
    
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"car/list_info",@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"account_id":fromUserID,@"car_id":carid,@"business_car_id":buscarid} success:^(id response) {
        self.allSourceDic = [response objectForKey:@"result_info"];
        [self.headView.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[self.allSourceDic objectForKey:@"account_share"] objectForKey:@"head_pic"]] forState:UIControlStateNormal];;
        self.headView.nameLB.text = [[self.allSourceDic objectForKey:@"account_share"] objectForKey:@"nickname"];
        
        //聊天小窗口
        if([NSString isEmptyString:[[self.allSourceDic objectForKey:@"account_belong"] objectForKey:@"content"]])
        {
            self.floatView.hidden = YES;
        }
        else
        {
            [self.floatView.headBtn sd_setBackgroundImageWithURL:[[self.allSourceDic objectForKey:@"account_belong"] objectForKey:@"head_pic"] forState:UIControlStateNormal];
            self.floatView.nicknameLB.text = [[self.allSourceDic objectForKey:@"account_belong"] objectForKey:@"nickname"];
            self.floatView.contentLB.text = [[self.allSourceDic objectForKey:@"account_belong"] objectForKey:@"content"];
        }
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForCarPicList
{
    NSString *carid = [self.sourceDic objectForKey:@"id"];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"car/attr_list",@"car_id":carid,@"detecte_total_name":@"车辆照片",@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        self.headView.bannerArr = [[response objectForKey:@"result_info"] objectForKey:@"attr_list"];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

#pragma mark - cell上按钮
-(void)callPhone
{
    [[QLToolsManager share] contactCustomerService:[[self.allSourceDic objectForKey:@"account_belong"] objectForKey:@"mobile"]];
}

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

//上下架
- (void)sellBtnClick
{
    if([self.bottomView.statusBtn.titleLabel.text isEqualToString:@"下架微店"])
    {
        //上架
        [self requestForUpLoadType:@"2"];
    }
    else
    {
        //下架
        [self requestForUpLoadType:@"1"];
    }
}

-(void)requestForUpLoadType:(NSString *)uploadStr
{
    NSString *carid = [self.sourceDic objectForKey:@"id"];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"car/deal",@"car_id":carid,@"state":uploadStr,@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {

        if([[response objectForKey:@"result_code"] intValue] == 0)
        {
            [MBProgressHUD showSuccess:[[response objectForKey:@"result_info"] objectForKey:@"result"]];
            if([uploadStr isEqualToString:@"1"])
            {
                [self setBottomBtnTitle:@"下架微店"];
            }
            else
            {
                [self setBottomBtnTitle:@"上架微店"];
            }
            
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)setBottomBtnTitle:(NSString *)bottomBtnTitle
{
    [self.bottomView.statusBtn setTitle:bottomBtnTitle forState:UIControlStateNormal];
}


#pragma mark - 导航栏
//分享
- (void)funBtnClick {
    
}
//返回
- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionChat
{
    NSString *fromUserID = [[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"belonger"];
    NSString *carid = [[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"id"];
    QLChatListPageViewController *con = [[QLChatListPageViewController alloc] initWithCarID:carid messageToID:fromUserID];
    [self.navigationController pushViewController:con animated:YES];
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
            if(self.allSourceDic)
            {
                cell.titleLB.text = [[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"model"];
            }
            return cell;
        } else {
            QLCarDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
            cell.contactBtn.hidden = NO;
            [cell.contactBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];

            if(self.allSourceDic)
            {
                cell.priceLB.text = [NSString stringWithFormat:@"批发价 %@",[[QLToolsManager share] unitConversion:[[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"sell_price"] floatValue]]];
                cell.accPriceLB.text = [NSString stringWithFormat:@"销售价：%@",[[QLToolsManager share] unitConversion:[[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"guide_price"] floatValue]]];
                
            }
            return cell;
        }
    } else if (indexPath.section == 1) {
        QLVehicleInstalmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instalmentCell" forIndexPath:indexPath];
        if(self.allSourceDic)
        {
            cell.priceLB.text = [NSString stringWithFormat:@"首付%@",[[QLToolsManager share] unitConversion:[[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"sell_pre_price"] floatValue]]];

        }
        return cell;
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            QLVehicleConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"configCell" forIndexPath:indexPath];
            if(self.allSourceDic)
            {
                [cell updateWithDic:self.allSourceDic];

            }
            return cell;
        } else {
            QLVehicleReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell" forIndexPath:indexPath];
            
            return cell;
        }
        
    } else {
        QLVehicleDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell" forIndexPath:indexPath];
        [cell.uploadControl addTarget:self action:@selector(uploadControlClick) forControlEvents:UIControlEventTouchUpInside];
        if(self.allSourceDic)
        {
            cell.contentLB.text = [[self.allSourceDic objectForKey:@"car_param"] objectForKey:@"car_desc"];
        }
        return cell;
    }
    
    

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2||section == 3) {
        QLCarDetailSectionView *sectionView = [QLCarDetailSectionView new];
        sectionView.titleLB.text = section==2?@"车辆信息":@"车辆描述";
        sectionView.moreBtn.tag = section;
        sectionView.moreBtn.hidden = section==2?NO:YES;
//        [sectionView.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
//        [sectionView.moreBtn addTarget:self action:@selector(headerAccBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
        [_bottomView.cancelBtn addTarget:self action:@selector(actionCancelHelp) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.moreBtn addTarget:self action:@selector(actionMore) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.statusBtn addTarget:self action:@selector(sellBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (QLChatFloatView *)floatView {
    if (!_floatView) {
        _floatView = [QLChatFloatView new];
        [_floatView.bgBtn addTarget:self action:@selector(actionChat) forControlEvents:UIControlEventTouchUpInside];
    }
    return _floatView;
}

-(void)actionMore
{
    NSString *ship_id = [[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"id"];
    NSString *business_id = [[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"business_id"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:ship_id,@"ship_id",[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"belonger"],@"accID",business_id,@"business_id", nil];
    QLContactsStoreViewController *csVC = [[QLContactsStoreViewController alloc] initWithDic:dic];
    csVC.isFromCarManager = YES;
    csVC.naviTitle = @"";
    [self.navigationController pushViewController:csVC animated:YES];
}

-(void)actionCancelHelp
{
    NSString *carid = [self.sourceDic objectForKey:@"id"];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"car/deal",@"car_id":carid,@"state":@"99",@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        if([[response objectForKey:@"result_code"] intValue] == 0)
        {
            [MBProgressHUD showSuccess:@"操作成功！"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

@end
