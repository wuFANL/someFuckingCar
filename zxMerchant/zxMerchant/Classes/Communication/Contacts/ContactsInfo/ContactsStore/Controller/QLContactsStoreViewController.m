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

@property (nonatomic, strong) NSMutableArray *carLiatArray;
@property (nonatomic, strong) NSMutableArray *chooseCarArr;

@property (nonatomic, strong) NSString *carIDd;
@property (nonatomic, strong) NSString *carPrice;

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
    self.carLiatArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self requestForStore];
    [self requestForStoreCarListWithCarID:@"" mixPrice:@"1" maxPrice:@"9999999"];
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
        NSArray *arry = [[response objectForKey:@"result_info"] objectForKey:@"brand_list"];
        [arry enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.brand_listAr addObjectsFromArray:[obj objectForKey:@"brand_list"]];
        }];
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForStoreCarListWithCarID:(NSString *)carID mixPrice:(NSString *)mixPrice maxPrice:(NSString *)maxPrice
{
    [MBProgressHUD showCustomLoading:@""];
    NSString *business_id = [self.sourceDic objectForKey:@"business_id"];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"car_page_list",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"business_id":business_id,@"brand_id":self.carIDd?:@"",@"min_price":mixPrice,@"max_price":maxPrice,@"page_no":@"1",@"page_size":@"100"} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        
        [self.carLiatArray removeAllObjects];
        [self.carLiatArray addObjectsFromArray:[[response objectForKey:@"result_info"] objectForKey:@"car_list"]];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)invokerData:(NSString *)price
{
    NSString *minP = @"1";
    NSString *maxP = @"9999999";
    if([price isEqualToString:@"不限价格"])
    {
        minP = @"1";
        maxP = @"9999999";
    }
    else if ([price isEqualToString:@"5万以内"])
    {
        minP = @"1";
        maxP = @"50000";
    }
    else if ([price isEqualToString:@"5万-10万"])
    {
        minP = @"50000";
        maxP = @"100000";
    }
    else if ([price isEqualToString:@"10万-15万"])
    {
        minP = @"100000";
        maxP = @"150000";
    }
    else if ([price isEqualToString:@"15万-20万"])
    {
        minP = @"150000";
        maxP = @"200000";
    }
    else if ([price isEqualToString:@"20万-30万"])
    {
        minP = @"200000";
        maxP = @"300000";
    }
    else if ([price isEqualToString:@"30万-50万"])
    {
        minP = @"300000";
        maxP = @"500000";
    }
    else if([price isEqualToString:@"50万以上"])
    {
        minP = @"500000";
        maxP = @"9999999";
    }
    
    [self requestForStoreCarListWithCarID:self.carIDd?:@"" mixPrice:minP maxPrice:maxP];

}

#pragma mark - action
//选择车辆
- (void)carChoose:(UIButton *)sender {
    NSInteger index = sender.tag;
    NSDictionary *carDic = [self.carLiatArray objectAtIndex:index];
    
    NSDictionary *chooseDic = nil;
    for (NSDictionary *dic in self.chooseCarArr) {
        if ([dic[@"id"] isEqualToString:carDic[@"id"]]) {
            chooseDic = dic;
        }
    }
    if (chooseDic) {
        [self.chooseCarArr removeObject:chooseDic];
    } else {
        [self.chooseCarArr addObject:carDic];
    }
    self.bottomView.allBtn.selected = self.chooseCarArr.count == self.carLiatArray.count?YES:NO;
    [self.tableView reloadData];

    
}
//全选
- (void)allBtnClick {
    
    self.bottomView.allBtn.selected = !self.bottomView.allBtn.selected;
    if (self.bottomView.allBtn.selected) {
        [self.chooseCarArr addObjectsFromArray:self.carLiatArray];
    } else {
        [self.chooseCarArr removeAllObjects];
    }
    
    [self.tableView reloadData];
}
//选车
- (void)funBtnClick {
    if (self.bottomView.isEditing == NO) {
        //选择车辆
        self.bottomView.isEditing = YES;
        [self.tableView reloadData];
    } else {
        //确定
        if([self.chooseCarArr count] > 0) {
            __block NSString *carList = @"";
            [self.chooseCarArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 if([carList isEqualToString:@""])
                 {
                     carList = [obj objectForKey:@"id"];
                 } else {
                     carList = [NSString stringWithFormat:@"%@,%@",carList,[obj objectForKey:@"id"]];
                 }
            }];
            
            [MBProgressHUD showCustomLoading:@""];
            NSString *business_id = [self.sourceDic objectForKey:@"business_id"];
            [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"select_car.",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"business_id":business_id,@"car_ids":carList,@"state":@"1"} success:^(id response) {
                [MBProgressHUD immediatelyRemoveHUD];
                [self cancelBtnClick];
                [self.tableView reloadData];
            } fail:^(NSError *error) {
                [MBProgressHUD showError:error.domain];
            }];
        }
    }
}
//取消
- (void)cancelBtnClick {
    self.bottomView.isEditing = NO;
    self.bottomView.allBtn.selected = NO;
    [self.chooseCarArr removeAllObjects];
    [self.tableView reloadData];
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
    return section == 0?2:[self.carLiatArray count];
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
            [cell setCarBlock:^(NSString * _Nonnull carID) {
                self.carIDd = carID;
                [self invokerData:self.carPrice];
            }];
            
            [cell setCarPriceBlock:^(NSString * _Nonnull price) {
                self.carPrice = price;
                [self invokerData:self.carPrice];
            }];
            
            [cell setAllBlock:^{
                self.carIDd = @"";
                self.carPrice = @"";
                [self invokerData:@""];
            }];
            return cell;
        }
        
    } else {
        QLContactsStoreCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsStoreCarCell" forIndexPath:indexPath];
        cell.isEditing = self.bottomView.isEditing;
        NSDictionary *dic = [self.carLiatArray objectAtIndex:indexPath.row];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"car_img"]]];
        cell.titleLB.text = [dic objectForKey:@"model"];
        cell.accLB.text = [NSString stringWithFormat:@"%@ | %@万公里",[dic objectForKey:@"production_year"],[dic objectForKey:@"driving_distance"]];
        cell.timeLB.text = [[[dic objectForKey:@"update_time"] componentsSeparatedByString:@" "] firstObject];
        cell.addressLB.text = [dic objectForKey:@"city_belong"];
        cell.priceLB.text = [NSString stringWithFormat:@"%.1f万",[[dic objectForKey:@"wholesale_price"] floatValue]/10000];
        
        cell.selectBtn.tag = indexPath.row;
        cell.selectBtn.selected = NO;
        [cell.selectBtn addTarget:self action:@selector(carChoose:) forControlEvents:UIControlEventTouchUpInside];
        
        for (NSDictionary *chooseDic in self.chooseCarArr) {
            if ([dic[@"id"] isEqualToString:chooseDic[@"id"]]) {
                cell.selectBtn.selected = YES;
            }
        }
        
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
        [_bottomView.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (NSMutableArray *)chooseCarArr {
    if (!_chooseCarArr) {
        _chooseCarArr = [NSMutableArray array];
    }
    return _chooseCarArr;
}
@end
