//
//  QLJoinStoreDetailViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/4/22.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLJoinStoreDetailViewController.h"
#import "QLBelongingShopBottomView.h"
#import "QLBelongingShopInfoCell.h"
#import "QLAccountInfoCell.h"
#import "QLSubmitImgConfigCell.h"

@interface QLJoinStoreDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBelongingShopBottomView *bottomView;
@property (nonatomic, strong) NSDictionary *dataDictionary;

@property (nonatomic, strong) NSDictionary *sourceDic;
@end

@implementation QLJoinStoreDetailViewController

-(id)initWithDataDic:(NSDictionary *)dataDic
{
    self = [super init];
    if(self)
    {
        self.dataDictionary = [dataDic copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请加入店铺";
    
    [self seeProgressRequest];
}

//查看加入车行进度
- (void)seeProgressRequest {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:UserPath params:self.dataDictionary success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.sourceDic = [response objectForKey:@"result_info"];
        int st = [[[self.sourceDic objectForKey:@"personnel"] objectForKey:@"state"] intValue];
        if(st == 99)
        {
            self.status = JoinFail;
        }
        else if (st == 1)
        {
            self.status = JoinSuccess;
        }
        else
        {
            self.status = WaitStoreAgreen;
        }
        
        [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(50);
        }];
        //tableView
        [self tableViewSet];
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

#pragma mark - action
//取消申请
- (void)cancelBtnClick {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"opinion",@"business_personnel_id":[[self.sourceDic objectForKey:@"personnel"] objectForKey:@"business_personnel_id"],@"state":@"2"} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLBelongingShopInfoCell" bundle:nil] forCellReuseIdentifier:@"belongingShopInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLAccountInfoCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLSubmitImgConfigCell" bundle:nil] forCellReuseIdentifier:@"submitImgConfigCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (self.status == WaitStoreAgreen) {
            return 3;
        } else {
            return 2;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QLBelongingShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"belongingShopInfoCell" forIndexPath:indexPath];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[[self.sourceDic objectForKey:@"business"] objectForKey:@"business_pic"]]];
        cell.storeNameLB.text = [[self.sourceDic objectForKey:@"business"] objectForKey:@"business_name"];
        cell.addressLB.text = [[self.sourceDic objectForKey:@"business"] objectForKey:@"address"];
        NSString *stat = @"";
        int st = [[[self.sourceDic objectForKey:@"personnel"] objectForKey:@"state"] intValue];
        if(st == 99)
        {
            stat = @"拒绝";
        }
        else if (st == 1)
        {
            stat = @"通过";
        }
        else
        {
            stat = @"申请中";
        }
        [cell.statusBtn setTitle:stat forState:UIControlStateNormal];
        return cell;
    } else {
        if (indexPath.row == 0||indexPath.row == 1) {
            QLAccountInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
            cell.callBtn.hidden = YES;
            if(indexPath.row == 0)
            {
                cell.titleLB.text = @"申请时间";
                cell.detailLB.text = [[self.sourceDic objectForKey:@"personnel"] objectForKey:@"create_time"];
            }
            else
            {
                cell.titleLB.text = @"审核时间";
                cell.detailLB.text = [[self.sourceDic objectForKey:@"personnel"] objectForKey:@"update_time"];
            }

            return cell;
        } else {
            QLSubmitImgConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submitImgConfigCell" forIndexPath:indexPath];
            cell.titleLBHeight.constant = 0;
            cell.titleLBBottom.constant = 0;
            cell.titleLB.hidden = YES;
            cell.aControl.tag = indexPath.row;
            cell.bControl.tag = indexPath.row;
            cell.aTitleLB.text = @"上传身份证正面";
            cell.bTitleLB.text = @"上传身份证反面";
            
            [cell.aImgView sd_setImageWithURL:[NSURL URLWithString:[[self.sourceDic objectForKey:@"account"] objectForKey:@"idcard_front_pic"]]];
            [cell.bImgView sd_setImageWithURL:[NSURL URLWithString:[[self.sourceDic objectForKey:@"account"] objectForKey:@"idcard_back_pic"]]];
            
            return cell;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header = [UIView new];
        
        UILabel *lb = [UILabel new];
        lb.font = [UIFont systemFontOfSize:15];
        lb.textColor = [UIColor darkGrayColor];
        lb.text = @"基本信息";
        [header addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).offset(16);
            make.centerY.equalTo(header);
        }];
        
        return header;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 || indexPath.row==2?120 : 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?0.01:40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - Lazy
- (QLBelongingShopBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLBelongingShopBottomView new];
    
        if (self.status == WaitStoreAgreen) {
            _bottomView.editBtn.hidden = YES;
            [_bottomView.cancelBtn setTitle:@"取消申请" forState:UIControlStateNormal];
            [_bottomView.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_bottomView);
            }];
            [_bottomView.cancelBtn  layoutButtonWithEdgeInsetsStyle:QLButtonEdgeInsetsStyleTop imageTitleSpace:5];
        } else {
            _bottomView.cancelBtn.hidden = YES;
            _bottomView.editBtn.hidden = YES;
        }
        [_bottomView.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

@end
