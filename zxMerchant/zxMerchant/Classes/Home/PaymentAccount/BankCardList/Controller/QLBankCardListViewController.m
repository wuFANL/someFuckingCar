//
//  QLBankCardListViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/29.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBankCardListViewController.h"
#import "QLBankEditCell.h"
#import "QLAddBankCardViewController.h"

@interface QLBankCardListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation QLBankCardListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //数据
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"我的银行卡" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"grayBack"] style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
    self.navigationItem.leftBarButtonItems = @[backItem,leftItem];
    //tableView
    [self tableViewSet];
}
#pragma mark- network
//获取数据
- (void)getData {
//    [MBProgressHUD showCustomLoading:nil];
//    [QLNetworkingManager postWithUrl:LoanPath params:@{@"operation_type":@"get_merchant_account",@"member_id":QLNONull([QLUserInfoModel getLocalInfo].merchant_staff.member_id)} success:^(id response) {
//        [MBProgressHUD immediatelyRemoveHUD];
//        self.bankArr = [[NSArray yy_modelArrayWithClass:[QLBankModel class] json:response[@"result_info"][@"bank_list"]] mutableCopy];
//        [self.tableView reloadData];
//    } fail:^(NSError *error) {
//        [MBProgressHUD showError:error.domain];
//    }];
    
}
//删除
- (void)deleteRequest:(NSString *)bank_id {
//    [MBProgressHUD showCustomLoading:nil];
//    [QLNetworkingManager postWithUrl:LoanPath params:@{@"operation_type":@"remove_merchant_bank",@"bank_id":bank_id,@"sub_id":[QLUserInfoModel getLocalInfo].merchant_staff.sub_id,@"member_id":[QLUserInfoModel getLocalInfo].merchant_staff.member_id} success:^(id response) {
//        [self.bankArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            QLBankModel *model = obj;
//            if ([model.bank_id isEqualToString:bank_id]) {
//                [self.bankArr removeObject:obj];
//            }
//        }];
//        [MBProgressHUD immediatelyRemoveHUD];
//         [self.tableView reloadData];
//    } fail:^(NSError *error) {
//        [MBProgressHUD showError:error.domain];
//    }];
}
#pragma mark- action
//编辑
- (void)editBtnClick:(UIButton *)sender {
    NSInteger section = sender.tag;
    QLAddBankCardViewController *abcVC = [QLAddBankCardViewController new];
    abcVC.bankModel = self.bankArr[section];
    [self.navigationController pushViewController:abcVC animated:YES];
}
//删除
- (void)deleteBtnClick:(UIButton *)sender {
    NSInteger section = sender.tag;
    [[QLToolsManager share] alert:@"确认删除该银行卡" handler:^(NSError *error) {
        if (!error) {
            QLBankModel *model = self.bankArr[section];
            [self deleteRequest:model.bank_id];
        }
    }];
    
}
//新增
- (void)addBtnClick {
    QLAddBankCardViewController *abcVC = [QLAddBankCardViewController new];
    [self.navigationController pushViewController:abcVC animated:YES];
}
//返回
- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLBankEditCell" bundle:nil] forCellReuseIdentifier:@"editCell"];
    //tableFooterView
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 500)];
    footer.backgroundColor = WhiteColor;
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setImage:[UIImage imageNamed:@"addCard"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footer);
        make.top.equalTo(footer).offset(30);
        make.width.mas_equalTo(118);
        make.height.mas_equalTo(30);
    }];
    self.tableView.tableFooterView = footer;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.bankArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QLBankModel *model = self.bankArr[indexPath.section];
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.text = model.real_name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | 尾号%@",model.bank_name,model.bank_card.length>4?[model.bank_card substringFromIndex:model.bank_card.length-4]:model.bank_card];
        return cell;
    } else {
        QLBankEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCell" forIndexPath:indexPath];
        cell.editBtn.tag = indexPath.section;
        cell.deleteBtn.tag = indexPath.section;
        [cell.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QLBankModel *model = self.bankArr[indexPath.section];
    if (self.chooseHandler) {
        self.chooseHandler(model, nil);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row==0?66:50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == [tableView numberOfSections]-1?10:0.5;
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
