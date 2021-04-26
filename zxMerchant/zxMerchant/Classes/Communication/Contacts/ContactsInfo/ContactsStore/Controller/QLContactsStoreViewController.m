//
//  QLContactsStoreViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLContactsStoreViewController.h"
#import "QLContactsDescCell.h"
#import "QLContactsStoreFilterItemsCell.h"
#import "QLContactsStoreCarCell.h"
#import "QLContactsStoreBottomView.h"

@interface QLContactsStoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLContactsStoreBottomView *bottomView;
@property (nonatomic, strong) NSMutableDictionary *sourceDic;

@property (nonatomic, strong) NSMutableDictionary *userInfoDic;
@property (nonatomic, strong) NSMutableDictionary *account_friendshipDic;
@property (nonatomic, strong) NSMutableDictionary *businessInfoDic;
@property (nonatomic, strong) NSMutableArray *brand_listAr;
@end

@implementation QLContactsStoreViewController

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        self.sourceDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.naviTitle;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"callIcon"] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
    }];

    self.userInfoDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.account_friendshipDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.businessInfoDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.brand_listAr = [[NSMutableArray alloc] initWithCapacity:0];
    [self requestForStore];
    //tableView
    [self tableViewSet];
}

-(void)requestForStore
{
    [MBProgressHUD showCustomLoading:@""];
    NSString *ship_id = [self.sourceDic objectForKey:@"ship_id"];
    NSString *business_id = [self.sourceDic objectForKey:@"business_id"];
    NSString *firendId = [self.sourceDic objectForKey:@"accID"];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"store",@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"business_id":business_id,@"account_id":firendId,@"ship_id":ship_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self.userInfoDic removeAllObjects];
        [self.userInfoDic addEntriesFromDictionary:[[response objectForKey:@"result_info"] objectForKey:@"user_info"]];
                                                    
        [self.account_friendshipDic removeAllObjects];
        [self.account_friendshipDic addEntriesFromDictionary:[[response objectForKey:@"result_info"] objectForKey:@"account_friendship"]];
        
        [self.businessInfoDic removeAllObjects];
        [self.businessInfoDic addEntriesFromDictionary:[[response objectForKey:@"result_info"] objectForKey:@"business_info"]];
        
        [self.brand_listAr removeAllObjects];
        [self.brand_listAr addObjectsFromArray:[[response objectForKey:@"result_info"] objectForKey:@"brand_list"]];
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForStoreCarList
{
//    [MBProgressHUD showCustomLoading:@""];
//    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"car_page_list",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"to_account_id":self.firendId} success:^(id response) {
//        [MBProgressHUD immediatelyRemoveHUD];
//    } fail:^(NSError *error) {
//        [MBProgressHUD showError:error.domain];
//    }];
}

#pragma mark - action

//全选
- (void)allBtnClick {
    self.bottomView.allBtn.selected = !self.bottomView.allBtn.selected;
    [self.tableView reloadData];
}
//选车
- (void)funBtnClick {
    if (self.bottomView.isEditing == NO) {
        //选择车辆
        self.bottomView.isEditing = YES;
    } else {
        //确定
        
    }
}
//电话
- (void)rightItemClick {
    if(![NSString isEmptyString:[self.userInfoDic objectForKey:@"mobile"]])
    {
        [[QLToolsManager share] contactCustomerService:[self.userInfoDic objectForKey:@"mobile"]];
    }
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLContactsDescCell" bundle:nil] forCellReuseIdentifier:@"contactsDescCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLContactsStoreFilterItemsCell" bundle:nil] forCellReuseIdentifier:@"filterItemsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLContactsStoreCarCell" bundle:nil] forCellReuseIdentifier:@"contactsStoreCarCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?2:5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QLContactsDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsDescCell" forIndexPath:indexPath];
            cell.collectionBtn.hidden = NO;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[self.userInfoDic objectForKey:@"head_pic"]]];
            cell.nikenameLB.text = [self.userInfoDic objectForKey:@"nickname"];
            cell.numLB.text = [NSString stringWithFormat:@"地区: %@",[self.userInfoDic objectForKey:@"address"]];
            cell.addressLB.text = [NSString stringWithFormat:@"%lu辆车在售",(unsigned long)[self.brand_listAr count]];
            return cell;
        } else {
            QLContactsStoreFilterItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterItemsCell" forIndexPath:indexPath];
            cell.carIconCollectionView.dataArr = [self.brand_listAr mutableCopy];
            return cell;
        }
        
    } else {
        QLContactsStoreCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsStoreCarCell" forIndexPath:indexPath];
        cell.isEditing = self.bottomView.allBtn.selected;
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 85;
        } else {
            return 140;
        }
    } else {
        return 120;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
#pragma mark - Lazy
- (QLContactsStoreBottomView *)bottomView {
    if(!_bottomView) {
        _bottomView = [QLContactsStoreBottomView new];
        _bottomView.allBtn.hidden = YES;
        _bottomView.allBtnWidth.constant = 0;
        
        [_bottomView.allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
@end
