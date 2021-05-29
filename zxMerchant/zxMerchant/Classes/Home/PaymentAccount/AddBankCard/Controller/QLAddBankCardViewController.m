//
//  QLAddBankCardViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/5/16.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLAddBankCardViewController.h"
#import "QLContentTFCell.h"
#import "QLAddVerificationView.h"

@interface QLAddBankCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加银行卡";
    //tableView
    [self tableViewSet];
    
}
#pragma mark- network
- (void)saveRequest {
    [MBProgressHUD showCustomLoading:nil];
    [QLNetworkingManager postWithUrl:LoanPath params:@{@"operation_type":@"save_merchant_bank_info",@"bank_id":QLNONull(self.bankModel.bank_id),@"real_name":self.bankModel.real_name,@"bank_card":self.bankModel.bank_card,@"bank_name":self.bankModel.bank_name,@"business_id":[QLUserInfoModel getLocalInfo].business.business_id} success:^(id response) {
        [MBProgressHUD showSuccess:@"操作成功"];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:HUDDefaultShowTime];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
    
}
#pragma mark- action
//输入框变化
- (void)textChange:(UITextField *)tf {
    NSInteger row = tf.tag;
    if (row == 0) {
        self.bankModel.real_name = tf.text;
    } else if (row == 1) {
        self.bankModel.bank_card = tf.text;
    } else {
        self.bankModel.bank_name = tf.text;
    }
}
//获取验证码
- (void)codeBtnClick {
    
}
//保存
- (void)saveBtnClick {
    if (self.bankModel.real_name.length == 0) {
        [MBProgressHUD showError:@"请输入持卡人姓名"];
        return;
    } else if (self.bankModel.bank_name.length == 0) {
        [MBProgressHUD showError:@"请输入银行名称"];
        return;
    } else if (self.bankModel.bank_card.length == 0) {
        [MBProgressHUD showError:@"请输入银行卡"];
        return;
    }
    [self saveRequest];
}
#pragma mark- tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:WhiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLContentTFCell" bundle:nil] forCellReuseIdentifier:@"tfCell"];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLContentTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tfCell" forIndexPath:indexPath];
    cell.lineView.hidden = NO;
    cell.accImgView.hidden = YES;
    cell.contentTF.tag = indexPath.row;
    if (indexPath.row == 0) {
        cell.titleLB.text = @"持卡人";
        cell.contentTF.placeholder = @"请输入姓名";
        cell.contentTF.text = self.bankModel.real_name;
    } else if (indexPath.row == 1) {
        cell.titleLB.text = @"卡号";
        cell.contentTF.placeholder = @"请输入银行卡号";
        cell.contentTF.text = self.bankModel.bank_card;
    } else {
        cell.titleLB.text = @"银行";
        cell.contentTF.placeholder = @"请选择银行";
        cell.contentTF.text = self.bankModel.bank_name;
    }
    [cell.contentTF addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [UIView new];
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    QLAddVerificationView *avView = [QLAddVerificationView new];
    if (!self.verifyAccount) {
        //不需要验证账号
        avView.tfView.hidden = YES;
        avView.tfViewHeight.constant = 0;
        avView.accountLB.text = @"";
    }
    [avView.codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [avView.saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return avView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 300;
}
#pragma mark- lazyLoading
- (QLBankModel *)bankModel {
    if (!_bankModel) {
        _bankModel = [QLBankModel new];
    }
    return _bankModel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
