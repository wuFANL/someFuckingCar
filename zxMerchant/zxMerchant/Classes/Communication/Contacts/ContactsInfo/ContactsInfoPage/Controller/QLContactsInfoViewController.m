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
#import "QLChatListPageViewController.h"
@interface QLContactsInfoViewController ()<UIPopoverPresentationControllerDelegate,PopViewControlDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseButton *moreBtn;
@property (nonatomic, strong) NSString *firendId;

@property (nonatomic, strong) NSMutableDictionary *userInfoDic;
@property (nonatomic, strong) NSMutableDictionary *dynamicListDic;
@property (nonatomic, strong) NSMutableDictionary *businessStoreDic;
@property (nonatomic, strong) NSMutableDictionary *friendShipDic;
@end

@implementation QLContactsInfoViewController
-(id)initWithFirendID:(NSString *)firendID
{
    self = [super init];
    if(self)
    {
        self.firendId = [NSString stringWithString:firendID];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    [self requestForFirendshipInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //navigation
    if (self.contactRelation == Friend) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    self.userInfoDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.dynamicListDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.businessStoreDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.friendShipDic = [[NSMutableDictionary alloc] initWithCapacity:0];

    //tableView
    [self tableViewSet];
}
#pragma mark - request
-(void)requestForFirendshipInfo
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"info",@"account_id":self.firendId,@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self.userInfoDic removeAllObjects];
        [self.userInfoDic addEntriesFromDictionary:[[response objectForKey:@"result_info"] objectForKey:@"user_info"]];
        
        [self.dynamicListDic removeAllObjects];
        [self.dynamicListDic addEntriesFromDictionary:[[[response objectForKey:@"result_info"] objectForKey:@"dynamic_list"] firstObject]];
        
        [self.businessStoreDic removeAllObjects];
        [self.businessStoreDic addEntriesFromDictionary:[[response objectForKey:@"result_info"] objectForKey:@"business_store"]];
        
        [self.friendShipDic removeAllObjects];
        [self.friendShipDic addEntriesFromDictionary:[[response objectForKey:@"result_info"] objectForKey:@"friendship"]];
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

#pragma mark - action
//功能按钮
- (void)funBtnClick {
    if (self.contactRelation == Friend) {
        //@"发消息"
        //聊天
        QLChatListPageViewController *clpVC = [[QLChatListPageViewController alloc] initWithCarID:@"" messageToID:[self.userInfoDic objectForKey:@"account_id"]];
        clpVC.navigationItem.title = [self.userInfoDic objectForKey:@"nickname"];
        [self.navigationController pushViewController:clpVC animated:YES];
    } else {
       //@"添加到通讯录"
    }
}
//拨号
- (void)callPhoneClick {
    if(![NSString isEmptyString:[self.userInfoDic objectForKey:@"mobile"]])
    {
        [[QLToolsManager share] contactCustomerService:[self.userInfoDic objectForKey:@"mobile"]];
    }
}

//pop的cell设置
- (void)cell:(UITableViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    baseCell.textLabel.font = [UIFont systemFontOfSize:10];
    baseCell.textLabel.textAlignment = NSTextAlignmentCenter;
    baseCell.textLabel.textColor = [UIColor colorWithHexString:@"#797D81"];
    baseCell.textLabel.text = dataArr[indexPath.row];
}
//pop的cell点击 - 删除好友
- (void)popClickCall:(NSInteger)index {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"remove",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"to_account_id":self.firendId} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
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
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[self.userInfoDic objectForKey:@"head_pic"]]];
            cell.nikenameLB.text = [self.userInfoDic objectForKey:@"nickname"];
            cell.numLB.text = [NSString stringWithFormat:@"编号: %@",[self.userInfoDic objectForKey:@"account_number"]];
            cell.addressLB.text = [NSString stringWithFormat:@"地区: %@",[self.userInfoDic objectForKey:@"address"]];
            return cell;
        } else if (indexPath.row == 4) {
            QLContactsCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCircleCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLB.text = @"车友圈";
            if(self.dynamicListDic && [self.dynamicListDic count] > 0)
            {
                NSArray *ar = [self.dynamicListDic objectForKey:@"file_array"];
                [cell showImageWithArray:ar];
            }
            return cell;
        } else {
            QLContactsTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsTextCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 1) {
                cell.titleLB.text = @"设置备注";
                cell.contentLB.text = [NSString isEmptyString:[self.friendShipDic objectForKey:@"remark2"]] == YES?@"":[self.friendShipDic objectForKey:@"remark2"];
            } else if (indexPath.row == 2) {
                cell.titleLB.text = @"电话号码";
                cell.contentLB.text = [NSString isEmptyString:[self.userInfoDic objectForKey:@"mobile"]] == YES?@"":[self.userInfoDic objectForKey:@"mobile"];
                
                QLBaseButton *accBtn = [[QLBaseButton alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
                [accBtn setImage:[UIImage imageNamed:@"callIcon"] forState:UIControlStateNormal];
                [accBtn addTarget:self action:@selector(callPhoneClick) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = accBtn;
            } else {
                cell.titleLB.text = @"车友店";
                if([[self.businessStoreDic objectForKey:@"car_count"] intValue] > 0)
                {
                    cell.contentLB.text = [NSString stringWithFormat:@"%@辆车在售",[self.businessStoreDic objectForKey:@"car_count"]];
                }
                else
                {
                    cell.contentLB.text = @"0辆车在售";
                }
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
            rsVC.firendId = self.firendId;
            [self.navigationController pushViewController:rsVC animated:YES];
        } else if (indexPath.row == 3) {
            //车友店
            NSString *ship_id = [self.friendShipDic objectForKey:@"ship_id"];
            NSString *business_id = [self.businessStoreDic objectForKey:@"business_id"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:ship_id,@"ship_id",self.firendId,@"accID",business_id,@"business_id", nil];
            QLContactsStoreViewController *csVC = [[QLContactsStoreViewController alloc] initWithDic:dic];
            [self.navigationController pushViewController:csVC animated:YES];
        } else if (indexPath.row == 4) {
            //车友圈
            QLRidersDynamicViewController *rdVC = [QLRidersDynamicViewController new];
            rdVC.friendId = self.firendId;
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
