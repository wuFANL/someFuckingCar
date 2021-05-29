//
//  QLMyCarDetailViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/8.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLMyCarDetailViewController.h"
#import "QLMyCarDetailHeadView.h"
#import "QLMyCarDetailBottomView.h"
#import "QLCarDetailTextCell.h"
#import "QLCarDetailAccInfoCell.h"
#import "QLCarDetailPriceCell.h"
#import "QLVehicleInstalmentCell.h"
#import "QLVehicleConfigCell.h"
#import "QLVehicleReportCell.h"
#import "QLVehicleDescCell.h"
#import "QLHorizontalScrollCell.h"
#import "QLImageItem.h"
#import "QLCarDetailSectionView.h"
#import "QLChangePriceViewController.h"
#import "QLCarDescViewController.h"
#import "QLCarCertificateViewController.h"
#import "QLCustomSheetView.h"
#import "QLTransactionSubmitViewController.h"

@interface QLMyCarDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLMyCarDetailHeadView *headView;
@property (nonatomic, strong) QLMyCarDetailBottomView *bottomView;
//是否显示价格模块
@property (nonatomic, assign) BOOL showPrice;
//是否显示内部价格
@property (nonatomic, assign) BOOL showInternalPrice;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *carID;
@property (nonatomic, copy) NSString *buscarID;


@property (nonatomic, strong) NSArray *zjPicArr;

@property (nonatomic, copy) NSDictionary *allSourceDic;
@end

@implementation QLMyCarDetailViewController

-(id)initWithUserid:(NSString *)userID carID:(NSString *)carId {
    self = [super init];
    if(self)
    {
        self.userId = userID;
        self.carID = carId;
    }
    return self;
}

-(id)initWithUserid:(NSString *)userID carID:(NSString *)carId businessCarID:(NSString *)busCarID{
    self = [super init];
    if(self)
    {
        self.userId = userID;
        self.carID = carId;
        self.buscarID = busCarID;
    }
    return self;
}

-(void)requestForMsgInfo
{
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"car/info",@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"account_id":self.userId,@"car_id":self.carID} success:^(id response) {
        self.allSourceDic = [response objectForKey:@"result_info"];
        self.headView.numLB.text = self.carID;
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForMsgList
{
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"car/list_info",@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"account_id":self.userId,@"car_id":self.carID,@"business_car_id":self.buscarID} success:^(id response) {
        self.allSourceDic = [response objectForKey:@"result_info"];
        self.headView.numLB.text = self.carID;
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForCarPicList:(NSString *)carName
{
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"car/attr_list",@"car_id":self.carID,@"detecte_total_name":carName,@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        if([carName isEqualToString:@"车辆照片"])
        {
            self.headView.bannerArr = [[response objectForKey:@"result_info"] objectForKey:@"attr_list"];
            [self requestForCarPicList:@"证件照片"];
        }
        else
        {
            self.zjPicArr = [[[response objectForKey:@"result_info"] objectForKey:@"attr_list"] copy];
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForUpLoadType:(NSString *)uploadStr
{
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"car/deal",@"car_id":self.carID,@"state":uploadStr,@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车辆详情";
    if([NSString isEmptyString:self.buscarID])
    {
        [self requestForMsgInfo];
    } else {
        [self requestForMsgList];
    }
    
    [self requestForCarPicList:@"车辆照片"];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"share_green"] originalImage] style:UIBarButtonItemStyleDone target:self action:@selector(shareBtnClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
    }];
    //tableView
    [self tableViewSet];
    //默认设置
    self.showPrice = NO;
    self.showInternalPrice = YES;
}
#pragma mark - action
//出售
- (void)confirmBtnClick {
    QLCustomSheetView *sheetView = [QLCustomSheetView new];
    sheetView.listArr = @[@"店铺出售",@"合作出售"];
    sheetView.clickHandler = ^(id result, NSError *error) {
        NSInteger index = [result integerValue];
        if(index == -1)
        {
            return;
        }
        QLTransactionSubmitViewController *tsVC = [[QLTransactionSubmitViewController alloc] initWithSourceDic:[self.allSourceDic objectForKey:@"car_info"]];
        WEAKSELF;
        [tsVC setMsBlock:^(NSString * _Nonnull price, NSString * _Nonnull content) {
            if([price isEqualToString:@"1"])
            {
                //售出成功
                [weakSelf setBottomType:@"99"];
            }
        }];
        tsVC.isFromCarManager = YES;
        if (index == 0) {
            //店铺出售
            tsVC.type = ShopSale;
            tsVC.showBuyer = NO;
            tsVC.showDesc = NO;
        } else {
            //合作出售
            tsVC.type = CooperativeTransaction;
            tsVC.showBuyer = YES;
            tsVC.showDesc = YES;
            
        }
        [self.navigationController pushViewController:tsVC animated:YES];
    
    };
    [sheetView show];
}

//上下架
- (void)sellBtnClick
{
    if([self.bottomView.sellBtn.titleLabel.text isEqualToString:@"下架微店"])
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

//分区头部按钮
- (void)headerAccBtnClick:(UIButton *)sender {
    NSInteger section = sender.tag;
    if (section == 3) {
        //车辆描述
        [self uploadControlClick];
    } else {
        //车辆牌证
        QLCarCertificateViewController *ccVC = [QLCarCertificateViewController new];
        [self.navigationController pushViewController:ccVC animated:YES];
    }
}
//车辆描述
- (void)uploadControlClick {
    QLCarDescViewController *cdVC = [QLCarDescViewController new];
    [self.navigationController pushViewController:cdVC animated:YES];
}
//调价
- (void)reduceBtnClick {
    QLChangePriceViewController *cpVC = [QLChangePriceViewController new];
    cpVC.showInternalPrice = YES;
    [self.navigationController pushViewController:cpVC animated:YES];
}
//显示价格
- (void)showPriceBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.showPrice = !self.showPrice;
    [self.tableView reloadData];
}
//分享
- (void)shareBtnClick {

    
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarDetailTextCell" bundle:nil] forCellReuseIdentifier:@"titleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarDetailAccInfoCell" bundle:nil] forCellReuseIdentifier:@"accInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarDetailPriceCell" bundle:nil] forCellReuseIdentifier:@"priceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLVehicleInstalmentCell" bundle:nil] forCellReuseIdentifier:@"instalmentCell"];
    [self.tableView registerClass:[QLVehicleConfigCell class] forCellReuseIdentifier:@"configCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLVehicleReportCell" bundle:nil] forCellReuseIdentifier:@"reportCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLVehicleDescCell" bundle:nil] forCellReuseIdentifier:@"descCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView);
    }];
    
    //tableViewHead
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    [tableHeaderView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableHeaderView);
    }];
    self.tableView.tableHeaderView = tableHeaderView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        if (self.showPrice) {
            if (self.showInternalPrice) {
                return 5;
            } else {
                return 3;
            }
        } else {
            return 1;
        }
    } else if (section == 2) {
        return 2;
    } else {
        return 1;
    }
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
        } else if (indexPath.row == 1) {
            QLCarDetailAccInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accInfoCell" forIndexPath:indexPath];
            if(self.allSourceDic)
            {
                NSString *age = [NSString stringWithFormat:@"库龄%@天",[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"days"]];
                NSString *distents = [NSString stringWithFormat:@"%@万公里",[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"driving_distance"]];
                cell.iconArr = [@[[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"production_year"],distents,age] mutableCopy];
            }
            return cell;
        } else {
            QLCarDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
            cell.reduceBtn.hidden = NO;
            cell.internalPriceBtn.hidden = NO;
            [cell.reduceBtn addTarget:self action:@selector(reduceBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.internalPriceBtn addTarget:self action:@selector(showPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if(self.allSourceDic)
            {
                cell.priceLB.text = [[QLToolsManager share] unitConversion:[[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"sell_price"] floatValue]];
                cell.accPriceLB.text = [NSString stringWithFormat:@"新车指导价：%@",[[QLToolsManager share] unitConversion:[[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"guide_price"] floatValue]]];
                
            }

            return cell;
        }
    } else if (indexPath.section == 1) {
        if (self.showPrice&&indexPath.row < ([tableView numberOfRowsInSection:indexPath.section]-1)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"在线标价";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[QLToolsManager share] unitConversion:[[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"sell_price"] floatValue]]];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"销售底价";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[QLToolsManager share] unitConversion:[[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"sell_min_price"] floatValue]]];
            } else {
                if (self.showInternalPrice) {
                    if (indexPath.row == 2) {
                        cell.textLabel.text = @"批发价";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[QLToolsManager share] unitConversion:[[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"wholesale_price"] floatValue]]];
                    } else if(indexPath.row == 3) {
                        cell.textLabel.text = @"采购价";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[QLToolsManager share] unitConversion:[[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"procure_price"] floatValue]]];
                    }
                }
            }
            
            return cell;
        } else {
            QLVehicleInstalmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instalmentCell" forIndexPath:indexPath];
            if(self.allSourceDic)
            {
                cell.priceLB.text = [NSString stringWithFormat:@"首付%@",[[QLToolsManager share] unitConversion:[[[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"sell_pre_price"] floatValue]]];

            }
            return cell;
        }
        
    } else if (indexPath.section == [tableView numberOfSections]-3) {
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
    } else if (indexPath.section == [tableView numberOfSections]-2) {
        QLVehicleDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell" forIndexPath:indexPath];
        [cell.uploadControl addTarget:self action:@selector(uploadControlClick) forControlEvents:UIControlEventTouchUpInside];
        if(self.allSourceDic)
        {
            NSString* titleStr = [[self.allSourceDic objectForKey:@"car_info"] objectForKey:@"model"];
            // 里程数
            NSString* distance  = EncodeStringFromDic([self.allSourceDic objectForKey:@"car_info"], @"driving_distance");
            // 首次上牌 production_year
            NSString* production_year = EncodeStringFromDic([self.allSourceDic objectForKey:@"car_info"], @"production_year");
            // 档位
            NSString* transmission_case = EncodeStringFromDic([self.allSourceDic objectForKey:@"car_param"], @"transmission_case");
            cell.contentLB.text = [NSString stringWithFormat:@"%@,%@,%@,%@万公里",production_year,titleStr,transmission_case,distance];

        }
        return cell;
    } else {
        QLHorizontalScrollCell *cell = [[QLHorizontalScrollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"horizontalScrollCell"];
        QLItemModel *itemModel = [QLItemModel new];
        itemModel.rowCount = 1;
        itemModel.sectionInset = UIEdgeInsetsMake(0, 12, 0, 0);
        itemModel.Spacing = QLMinimumSpacingMake(10, 10);
        itemModel.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        itemModel.itemName = @"QLImageItem";
        itemModel.registerType = ITEM_NibRegisterType;
        itemModel.itemSize = CGSizeMake(74, 55);
        cell.itemModel = itemModel;
        cell.collectionViewHeight = 55;
        cell.itemArr  = self.zjPicArr;
        cell.itemSetHandler = ^(id result, NSError *error) {
            QLImageItem *item = result[@"item"];
            NSArray *dataArr = result[@"dataArr"];
            NSIndexPath *indexPath = result[@"indexPath"];
            item.backgroundColor = LightGrayColor;
            NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
            [item.imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic_url"]]];
        };
        cell.itemSelectHandler = ^(id result, NSError *error) {
            
        };
        
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2||section == 3||section == 4) {
        QLCarDetailSectionView *headerView = [QLCarDetailSectionView new];
        headerView.moreBtn.tag = section;
        headerView.editBtn.tag = section;
        if (section == 2) {
            headerView.titleLB.text = @"车辆信息";
           
            headerView.moreBtn.hidden = NO;
            [headerView.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
            [headerView.moreBtn addTarget:self action:@selector(headerAccBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        } else if (section == 3||section == 4) {
            headerView.titleLB.text = section == 3?@"车辆描述":@"车辆牌证";
            headerView.editBtn.hidden = NO;
            [headerView.editBtn addTarget:self action:@selector(headerAccBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    } else if (section == 1) {
        return 5;
    } else if (section == 2||section == 3||section == 4) {
        return 44;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    } else if (section == 1) {
        return 5;
    } else if (section == 4) {
        return 35;
    }
    return 0.01;
}
#pragma mark - Lazy
- (QLMyCarDetailHeadView *)headView {
    if (!_headView) {
        _headView = [QLMyCarDetailHeadView new];
    }
    return _headView;
}
- (QLMyCarDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLMyCarDetailBottomView new];
        [_bottomView.confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.sellBtn addTarget:self action:@selector(sellBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        _bottomView.hidden = YES;
    }
    return _bottomView;
}

-(void)setBottomType:(NSString *)bottomType
{
    if([bottomType isEqualToString:@"0"])
    {
        self.bottomView.openControl.hidden = NO;
        self.bottomView.sellBtn.hidden =YES;
        self.bottomView.editBtn.hidden = YES;
        self.bottomView.confirmBtn.hidden = YES;
        self.bottomView.placeholderLB.text = [NSString stringWithFormat:@"找车源上架审核失败，请点击下方编辑按钮修改后重新提交审核：%@",self.refuseStr];
        [self.bottomView defaultOpen];
    }
    else if([bottomType isEqualToString:@"1"])
    {
        self.bottomView.openControl.hidden = YES;
        self.bottomView.sellBtn.hidden =NO;
        self.bottomView.editBtn.hidden = NO;
        self.bottomView.confirmBtn.hidden = NO;
    }
    else if([bottomType isEqualToString:@"99"])
    {
        //已出售
        self.bottomView.openControl.hidden = YES;
        self.bottomView.sellBtn.hidden =YES;
        self.bottomView.editBtn.hidden = YES;
        self.bottomView.confirmBtn.hidden = YES;
        self.bottomView.hasSellLab.hidden = NO;
    }
    else
    {
        self.bottomView.hidden = YES;
    }
}

-(void)setBottomBtnTitle:(NSString *)bottomBtnTitle
{
    [self.bottomView.sellBtn setTitle:bottomBtnTitle forState:UIControlStateNormal];
}

@end
