//
//  QLContactsInfoViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/7.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLContactsInfoViewController.h"
#import "QLContactsDescCell.h"
#import "QLContactsTextCell.h"
#import "QLContactsCircleCell.h"
#import "QLRemarksSetViewController.h"
#import "QLContactsStoreViewController.h"
#import "QLRidersDynamicViewController.h"

@interface QLContactsInfoViewController ()<UIPopoverPresentationControllerDelegate,PopViewControlDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseButton *moreBtn;
@property (nonatomic, strong) NSString *firendId;
@end

@implementation QLContactsInfoViewController
-(id)initWithFirendID:(NSString *)firendID
{
    self = [super init];
    if(self)
    {
        self.firendId = firendID;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //navigation
    if (self.contactRelation == Friend) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    [self requestForFirendshipInfo];
    
    //tableView
    [self tableViewSet];
}
#pragma mark - request
-(void)requestForFirendshipInfo
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"info",@"account_id":self.firendId,@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];

        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

#pragma mark - action
//功能按钮
- (void)funBtnClick {
    
}
//拨号
- (void)callPhoneClick {
    [[QLToolsManager share] contactCustomerService:@"111"];
}
//pop的cell设置
- (void)cell:(UITableViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    baseCell.textLabel.font = [UIFont systemFontOfSize:10];
    baseCell.textLabel.textAlignment = NSTextAlignmentCenter;
    baseCell.textLabel.textColor = [UIColor colorWithHexString:@"#797D81"];
    baseCell.textLabel.text = dataArr[indexPath.row];
}
//pop的cell点击
- (void)popClickCall:(NSInteger)index {
    
}
//pop样式
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}
//更多按钮点击
- (void)moreBtnClick {
    [QLPopoverShowManager showPopover:@[@"删除车友"] areaView:self.moreBtn direction:UIPopoverArrowDirectionAny backgroundColor:WhiteColor delegate:self];
}

#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLContactsDescCell" bundle:nil] forCellReuseIdentifier:@"contactsDescCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLContactsTextCell" bundle:nil] forCellReuseIdentifier:@"contactsTextCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLContactsCircleCell" bundle:nil] forCellReuseIdentifier:@"contactsCircleCell"];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?5:1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QLContactsDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsDescCell" forIndexPath:indexPath];
            
            return cell;
        } else if (indexPath.row == 4) {
            QLContactsCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCircleCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLB.text = @"车友圈";
            
            
            return cell;
        } else {
            QLContactsTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsTextCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 1) {
                cell.titleLB.text = @"设置备注";
                cell.contentLB.text = @"有备注传,没有空着";
            } else if (indexPath.row == 2) {
                cell.titleLB.text = @"电话号码";
                cell.contentLB.text = @"18977889991";
                
                QLBaseButton *accBtn = [[QLBaseButton alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
                [accBtn setImage:[UIImage imageNamed:@"callIcon"] forState:UIControlStateNormal];
                [accBtn addTarget:self action:@selector(callPhoneClick) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = accBtn;
            } else {
                cell.titleLB.text = @"车友店";
                cell.contentLB.text = @"0辆车在售";
            }
            return cell;
        }
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //按钮
        QLBaseButton *funBtn = [QLBaseButton new];
        [funBtn layoutButtonWithEdgeInsetsStyle:QLButtonEdgeInsetsStyleRight imageTitleSpace:-10];
        funBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [funBtn setTitleColor:[UIColor colorWithHexString:@"#006699"] forState:UIControlStateNormal];
        [funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
        if (self.contactRelation == Friend) {
            [funBtn setImage:[UIImage imageNamed:@"contactSendMsg"] forState:UIControlStateNormal];
            [funBtn setTitle:@"发消息" forState:UIControlStateNormal];
        } else {
            [funBtn setImage:nil forState:UIControlStateNormal];
            [funBtn setTitle:@"添加到通讯录" forState:UIControlStateNormal];
        }
        [cell.contentView addSubview:funBtn];
        [funBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            //备注
            QLRemarksSetViewController *rsVC = [QLRemarksSetViewController new];
            [self.navigationController pushViewController:rsVC animated:YES];
        } else if (indexPath.row == 3) {
            //车友店
            QLContactsStoreViewController *csVC = [QLContactsStoreViewController new];
            [self.navigationController pushViewController:csVC animated:YES];
        } else if (indexPath.row == 4) {
            //车友圈
            QLRidersDynamicViewController *rdVC = [QLRidersDynamicViewController new];
            [self.navigationController pushViewController:rdVC animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 90;
        } else if (indexPath.row == 4) {
            return 72;
        } else {
            return 44;
        }
    } else {
        return 56;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
#pragma mark - Lazy
- (QLBaseButton *)moreBtn {
    if(!_moreBtn) {
        _moreBtn = [[QLBaseButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [_moreBtn setImage:[UIImage imageNamed:@"moreIcon_black"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
@end
