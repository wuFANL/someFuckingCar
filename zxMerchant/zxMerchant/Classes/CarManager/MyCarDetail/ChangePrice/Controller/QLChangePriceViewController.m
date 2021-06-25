//
//  QLChangePriceViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/10/14.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLChangePriceViewController.h"
#import "QLCarSourceManagerCell.h"
#import "QLVehicleEditPriceCell.h"
#import "QLSubmitBottomView.h"

@interface QLChangePriceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLSubmitBottomView *bottomView;
@property (nonatomic, strong) QLBaseTableView *tableView;
@property (nonatomic, assign) BOOL contain_transfer_fee;
@property (nonatomic, weak) UITextField *aTF;
@property (nonatomic, weak) UITextField *bTF;
@property (nonatomic, weak) UITextField *cTF;
@property (nonatomic, weak) UITextField *dTF;
@property (nonatomic, strong) NSDictionary *sourceDic;
@end

@implementation QLChangePriceViewController

-(id)initWithSourceDic:(NSDictionary *)sourceDic
{
    self = [super init];
    if(self) {
        self.sourceDic = [sourceDic copy];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑价格";
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(44);
    }];
    //tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];

}
#pragma mark - network
- (void)changePriceRequest {
    [MBProgressHUD showCustomLoading:nil];

    [QLNetworkingManager postWithUrl:VehiclePath params:@{@"operation_type":@"save_price",
                                                          @"sell_price":QLNONull(self.aTF.text),
                                                          @"sell_min_price":QLNONull(self.bTF.text),
                                                          @"wholesale_price":QLNONull(self.cTF.text),
                                                          @"procure_price":QLNONull(self.dTF.text),
                                                          @"business_id":QLNONull([[self.sourceDic objectForKey:@"car_info"] objectForKey:@"business_id"]),
                                                          @"car_id":QLNONull([[self.sourceDic objectForKey:@"car_info"] objectForKey:@"id"])} success:^(id response) {
        [MBProgressHUD showSuccess:@"调价成功"];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:HUDDefaultShowTime];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changePrice" object:nil];
        
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - action
//是否包含过户费
- (void)accBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.contain_transfer_fee = sender.selected;
}
//确定
- (void)submitBtnClick {
    if (self.aTF.text.length == 0||self.bTF.text.length==0||self.cTF.text.length==0||self.dTF.text.length==0) {
        [MBProgressHUD showError:@"请填写完整"];
        return;
    } 
    [self changePriceRequest];
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?1:self.showInternalPrice?4:2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QLCarSourceManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carSourceManagerCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showFunView = NO;
        cell.statusBtn.hidden = YES;
        cell.prePriceLB.hidden = YES;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"car_img"]]];

        cell.titleLB.text = [[self.sourceDic objectForKey:@"car_info"] objectForKey:@"model"];
        cell.desLB.text = [NSString stringWithFormat:@"%@ | %@万公里",[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"production_year"],[[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"driving_distance"] stringValue]];
        
        NSString *moneyStr = [NSString stringWithFormat:@"%@万",[[QLToolsManager share] unitMileage:[[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"sell_price"] floatValue]]];
        [cell.priceBtn setTitle:moneyStr forState:UIControlStateNormal];
        cell.prePriceLB.text = [NSString stringWithFormat:@"首付%@万",[[QLToolsManager share] unitMileage:[[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"sell_pre_price"] floatValue]]];
        return cell;
    } else {
        QLVehicleEditPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCell" forIndexPath:indexPath];
        cell.tf.keyboardType = UIKeyboardTypeDecimalPad;
        cell.accBtn.hidden = YES;
        cell.moneyLB.textColor = GreenColor;
        //在线标价
        NSString *price1 = [[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"sell_price"] stringValue];
        //销售底价
        NSString *price2 = [[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"sell_min_price"] stringValue];
        //批发价
        NSString *price3 = [[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"wholesale_price"] stringValue];
        //采购价
        NSString *price4 = [[[self.sourceDic objectForKey:@"car_info"] objectForKey:@"procure_price"] stringValue];
        if (indexPath.row == 0) {
            cell.accBtn.hidden = NO;
            [cell.accBtn addTarget:self action:@selector(accBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.moneyLB.textColor = [UIColor redColor];
            cell.titleLB.text = @"在线标价(元)";
            cell.tf.placeholder = @"请输入在线标价";
            cell.moneyLB.text = price1;
            cell.tf.text = @"";
            self.aTF = cell.tf;
        } else if (indexPath.row == 1) {
            cell.titleLB.text = @"销售底价(元)";
            cell.tf.placeholder = @"请输入销售底价供员工参考";
            cell.moneyLB.text = price2;
            cell.tf.text = @"";
            self.bTF = cell.tf;
        } else if (indexPath.row == 2) {
            cell.titleLB.text = @"批发价(元)";
            cell.tf.placeholder = @"请输入批发价";
            cell.moneyLB.text = price3;
            cell.tf.text = @"";
            self.cTF = cell.tf;
        } else {
            cell.titleLB.text = @"采购价(元)";
            cell.tf.placeholder = @"请输入采购价";
            cell.moneyLB.text = price4;
            cell.tf.text = @"";
            self.dTF = cell.tf;
        }
        
       
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 300;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
#pragma mark - 懒加载
- (QLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource= self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerNib:[UINib nibWithNibName:@"QLCarSourceManagerCell" bundle:nil] forCellReuseIdentifier:@"carSourceManagerCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"QLVehicleEditPriceCell" bundle:nil] forCellReuseIdentifier:@"editCell"];
    }
    return _tableView;
}
- (QLSubmitBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLSubmitBottomView new];
        [_bottomView.funBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_bottomView.funBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}



@end
