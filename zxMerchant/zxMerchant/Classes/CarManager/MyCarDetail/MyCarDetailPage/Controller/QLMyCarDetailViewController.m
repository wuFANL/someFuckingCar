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
@end

@implementation QLMyCarDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车辆详情";
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
        
        QLTransactionSubmitViewController *tsVC = [QLTransactionSubmitViewController new];
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
        make.bottom.equalTo(self.bottomView.mas_top).offset(35);
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
            
            return cell;
        } else if (indexPath.row == 1) {
            QLCarDetailAccInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accInfoCell" forIndexPath:indexPath];
            cell.iconArr = [@[@"2010年",@"13.04万公里",@"库龄123天"] mutableCopy];
            return cell;
        } else {
            QLCarDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
            cell.reduceBtn.hidden = NO;
            cell.internalPriceBtn.hidden = NO;
            [cell.reduceBtn addTarget:self action:@selector(reduceBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.internalPriceBtn addTarget:self action:@selector(showPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
                cell.detailTextLabel.text = @"-";
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"销售底价";
                cell.detailTextLabel.text = @"-";
            } else {
                if (self.showInternalPrice) {
                    if (indexPath.row == 2) {
                        cell.textLabel.text = @"批发价";
                        cell.detailTextLabel.text = @"-";
                    } else if(indexPath.row == 3) {
                        cell.textLabel.text = @"采购价";
                        cell.detailTextLabel.text = @"-";
                    }
                }
            }
            
            return cell;
        } else {
            QLVehicleInstalmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instalmentCell" forIndexPath:indexPath];
            
            return cell;
        }
        
    } else if (indexPath.section == [tableView numberOfSections]-3) {
        if (indexPath.row == 0) {
            QLVehicleConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"configCell" forIndexPath:indexPath];

            return cell;
        } else {
            QLVehicleReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell" forIndexPath:indexPath];
            
            return cell;
        }
    } else if (indexPath.section == [tableView numberOfSections]-2) {
        QLVehicleDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell" forIndexPath:indexPath];
        [cell.uploadControl addTarget:self action:@selector(uploadControlClick) forControlEvents:UIControlEventTouchUpInside];
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
        cell.itemArr  = @[@"1",@"2",@"3"];
        cell.itemSetHandler = ^(id result, NSError *error) {
            QLImageItem *item = result[@"item"];
            NSArray *dataArr = result[@"dataArr"];
            NSIndexPath *indexPath = result[@"indexPath"];
            item.backgroundColor = LightGrayColor;
            
            
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
    }
    return _bottomView;
}
@end
