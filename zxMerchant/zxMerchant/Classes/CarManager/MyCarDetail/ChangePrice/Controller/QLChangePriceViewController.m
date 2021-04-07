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

@end

@implementation QLChangePriceViewController

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

        
        return cell;
    } else {
        QLVehicleEditPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCell" forIndexPath:indexPath];
        cell.tf.keyboardType = UIKeyboardTypeDecimalPad;
        cell.accBtn.hidden = YES;
        cell.moneyLB.textColor = GreenColor;
        if (indexPath.row == 0) {
            cell.accBtn.hidden = NO;
            [cell.accBtn addTarget:self action:@selector(accBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.moneyLB.textColor = [UIColor redColor];
            cell.titleLB.text = @"在线标价(元)";
            cell.tf.placeholder = @"请输入在线标价";
            cell.moneyLB.text = @"40000";
            cell.tf.text = @"";
            self.aTF = cell.tf;
        } else if (indexPath.row == 1) {
            cell.titleLB.text = @"销售底价(元)";
            cell.tf.placeholder = @"请输入销售底价供员工参考";
            cell.moneyLB.text = @"40000";
            cell.tf.text = @"";
            self.bTF = cell.tf;
        } else if (indexPath.row == 2) {
            cell.titleLB.text = @"批发价(元)";
            cell.tf.placeholder = @"请输入批发价";
            cell.moneyLB.text = @"40000";
            cell.tf.text = @"";
            self.cTF = cell.tf;
        } else {
            cell.titleLB.text = @"采购价(元)";
            cell.tf.placeholder = @"请输入采购价";
            cell.moneyLB.text = @"40000";
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
