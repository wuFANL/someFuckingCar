//
//  QLTransactionSubmitViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/15.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLTransactionSubmitViewController.h"
#import "QLTransactionInfoCell.h"
#import "QLTransactionMoneyCell.h"
#import "QLTransactionChooseBuyerCell.h"
#import "QLCreatStoreTVCell.h"
#import "QLSubmitBottomView.h"
#import "QLChooseBuyerViewController.h"

@interface QLTransactionSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLSubmitBottomView *bottomView;
@property (nonatomic, strong) NSDictionary *sourceDic;
@property (nonatomic, strong) QLTransactionMoneyCell *currentMoneyCell;
@property (nonatomic, strong) QLCreatStoreTVCell *currentStoreCell;

@end

@implementation QLTransactionSubmitViewController

-(id)initWithSourceDic:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        self.sourceDic = [dic copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.type == CooperativeTransaction?@"合作出售":self.type == TransactionContract?@"交易认证":@"店铺出售";
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
#pragma mark - setter
- (void)setShowBuyer:(BOOL)showBuyer {
    _showBuyer = showBuyer;
    [self.tableView reloadData];
}
- (void)setShowDesc:(BOOL)showDesc {
    _showDesc = showDesc;
    [self.tableView reloadData];
}
#pragma mark - action
//确定按钮
- (void)funBtnClick {
    if([NSString isEmptyString:self.currentMoneyCell.tf.text])
    {
        [MBProgressHUD showError:@"请填写价格"];
        return;
    }
    NSString *contentStr = self.currentStoreCell.tv.text;
    if([NSString isEmptyString:self.currentStoreCell.tv.text])
    {
        contentStr = [NSString stringWithFormat:@"%@, %@, %@万公里, 过户%@次",[self.sourceDic objectForKey:@"model"],[self.sourceDic objectForKey:@"vin_code"],[[self.sourceDic objectForKey:@"driving_distance"] stringValue],[[self.sourceDic objectForKey:@"transfer_times"] stringValue]];
    }
    if(self.msBlock)
    {
        self.msBlock(self.currentMoneyCell.tf.text,contentStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLTransactionInfoCell" bundle:nil] forCellReuseIdentifier:@"transactionInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLTransactionMoneyCell" bundle:nil] forCellReuseIdentifier:@"transactionMoneyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLTransactionChooseBuyerCell" bundle:nil] forCellReuseIdentifier:@"chooseBuyerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCreatStoreTVCell" bundle:nil] forCellReuseIdentifier:@"tvCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2+(self.showBuyer?1:0)+(self.showDesc?1:0);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QLTransactionInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transactionInfoCell" forIndexPath:indexPath];
        [cell.carImageV sd_setImageWithURL:[NSURL URLWithString:[self.sourceDic objectForKey:@"car_img"]]];
        cell.carNameLab.text = [self.sourceDic objectForKey:@"model"];
        cell.carContentLab.text = [NSString stringWithFormat:@"%@ | %@ | %@",[self.sourceDic objectForKey:@"production_year"],[[self.sourceDic objectForKey:@"driving_distance"] stringValue],[self.sourceDic objectForKey:@"city_belong"]];
        
        return cell;
    } else if (indexPath.row == 1) {
        QLTransactionMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transactionMoneyCell" forIndexPath:indexPath];
        self.currentMoneyCell = cell;
        
        return cell;
    } else if (indexPath.row == 2&&self.showBuyer) {
        QLTransactionChooseBuyerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseBuyerCell" forIndexPath:indexPath];
        
        return cell;
    } else if(indexPath.row == ([tableView numberOfRowsInSection:indexPath.section]-1)&&self.showDesc) {
        QLCreatStoreTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tvCell" forIndexPath:indexPath];
        self.currentStoreCell = cell;
        cell.tv.backgroundColor = WhiteColor;
        cell.tv.constraintLB.hidden = YES;
        cell.tv.placeholder = [NSString stringWithFormat:@"%@, %@, %@万公里, 过户%@次",[self.sourceDic objectForKey:@"model"],[self.sourceDic objectForKey:@"vin_code"],[[self.sourceDic objectForKey:@"driving_distance"] stringValue],[[self.sourceDic objectForKey:@"transfer_times"] stringValue]];
    
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2&&self.showBuyer) {
        //选择购车人
        QLChooseBuyerViewController *cbVC = [QLChooseBuyerViewController new];
        [self.navigationController pushViewController:cbVC animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = WhiteColor;
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 90;
    } else if (indexPath.row == 1) {
        return 108;
    } else if (indexPath.row == 2&&self.showBuyer) {
        return 68;
    } else {
        return 80;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
#pragma mark - Lazy
- (QLSubmitBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLSubmitBottomView new];
        [_bottomView.funBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_bottomView.funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
@end
