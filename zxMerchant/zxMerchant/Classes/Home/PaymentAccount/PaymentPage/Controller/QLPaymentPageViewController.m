//
//  QLPaymentPageViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/26.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLPaymentPageViewController.h"
#import "QLPaymentPageHeadView.h"
#import "QLBankCardCell.h"
#import "QLEidtPayCodeViewController.h"
#import "QLBankCardListViewController.h"
#import "QLPaymentPageModel.h"

@interface QLPaymentPageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseTableView *tableView;
@property (nonatomic, strong) QLPaymentPageHeadView *headView;
@property (nonatomic, strong) QLPaymentPageModel *model;
@end

@implementation QLPaymentPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //数据
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#DFB841"];
    self.navigationItem.title = @"收款账号";
    //tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 15, BottomOffset?-34:0, 15));
    }];
    
}
#pragma mark- network
- (void)getData {
//    [MBProgressHUD showCustomLoading:nil];
//    [QLNetworkingManager postWithUrl:LoanPath params:@{@"operation_type":@"get_merchant_account",@"member_id":QLNONull([QLUserInfoModel getLocalInfo].merchant_staff.member_id)} success:^(id response) {
//        [MBProgressHUD immediatelyRemoveHUD];
//        self.model = [QLPaymentPageModel yy_modelWithJSON:response[@"result_info"]];
//        self.headView.model = self.model;
//        [self.tableView reloadData];
//    } fail:^(NSError *error) {
//        [MBProgressHUD showError:error.domain];
//    }];
    
}
#pragma mark- action
//编辑二维码
- (void)editCodeBtn {
    QLEidtPayCodeViewController *epcVC = [QLEidtPayCodeViewController new];
    epcVC.model = self.model;
    [self.navigationController pushViewController:epcVC animated:YES];
}
//复制
- (void)cBtnClick:(UIButton *)sender {
    QLBankModel *model = self.model.bank_list[sender.tag];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"姓名:%@,银行:%@,银行卡号:%@",model.real_name,model.bank_name,model.bank_card];
    [MBProgressHUD showSuccess:@"复制成功!"];
}
#pragma mark- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ![[QLToolsManager share].homePageModel getFun:ZXInventory]?1:2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![[QLToolsManager share].homePageModel getFun:ZXInventory]) {
        return self.model.bank_list.count;
    } else {
        return section==0?1:self.model.bank_list.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0&&[[QLToolsManager share].homePageModel getFun:ZXInventory]) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor colorWithHexString:@"#CF9000"];
        cell.textLabel.textColor = WhiteColor;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = WhiteColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:@"cardIcon"];
        cell.textLabel.text = @"银行卡号";
        cell.detailTextLabel.text = @"编辑银行卡";
        
        return cell;
    } else {
        QLBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithHexString:@"#CF9000"];
        cell.nameLB.font = [UIFont systemFontOfSize:15];
        cell.bankLB.font = [UIFont systemFontOfSize:15];
        cell.nameLB.textColor = WhiteColor;
        cell.bankLB.textColor = WhiteColor;
        cell.cBtn.hidden = NO;
        cell.cBtn.tag = indexPath.row;
        [cell.cBtn addTarget:self action:@selector(cBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        QLBankModel *model = self.model.bank_list[indexPath.row];
        cell.nameLB.text = [NSString stringWithFormat:@"%@ | %@",model.bank_name,model.bank_card];
        cell.bankLB.text = model.real_name;
        return cell;
    }
 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0&&indexPath.row == 0&&[[QLToolsManager share].homePageModel getFun:ZXInventory]) {
        QLBankCardListViewController *bclVC = [QLBankCardListViewController new];
        [self.navigationController pushViewController:bclVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section==0?50:65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?10:0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}
#pragma mark- lazyLoading
- (QLBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[QLBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ClearColor;
        _tableView.delegate = self;
        _tableView.dataSource= self;
        [_tableView registerNib:[UINib nibWithNibName:@"QLBankCardCell" bundle:nil] forCellReuseIdentifier:@"cardCell"];
        //tableView
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 420)];
        [headView addSubview:self.headView];
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _tableView.tableHeaderView = headView;
    }
    return _tableView;
}
- (QLPaymentPageHeadView *)headView {
    if (!_headView) {
        _headView = [QLPaymentPageHeadView new];
        [_headView.editBtn addTarget:self action:@selector(editCodeBtn) forControlEvents:UIControlEventTouchUpInside];
        _headView.editBtn.hidden = ![[QLToolsManager share].homePageModel getFun:ZXInventory]?YES:NO;
    }
    return _headView;
}

@end
