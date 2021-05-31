//
//  QLEditTopCarViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/7.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLEditTopCarViewController.h"
#import "QLEditTopCarCell.h"
#import "QLEditTopCarItem.h"
#import "QLEditTopPriceView.h"

@interface QLEditTopCarViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate,QLBaseCollectionViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, strong) QLEditTopPriceView *priceView;
@property (nonatomic, strong) NSMutableArray *sourceArray;
@property (nonatomic, strong) NSMutableArray *botSourceArray;
@property (nonatomic, assign) NSInteger currentAddIndex;
@end

@implementation QLEditTopCarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"头条车源";
    self.sourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.botSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    //collectionView
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(140);
    }];
    //tableView
    [self tableViewSet];
    
    [self requestForTopCarList];
    [self requestForTopCarListBottom];
}
#pragma mark - network
-(void)dataRequest {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"top_car_list",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"local_state":@"1",@"flag":@"0",@"page_no":@(self.tableView.page),@"page_size":@(listShowCount)} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        
        if (self.tableView.page == 1) {
            [self.sourceArray removeAllObjects];
        }
        NSArray *temArr = [[response objectForKey:@"result_info"] objectForKey:@"car_list"];
        [self.sourceArray addObjectsFromArray:temArr];
        //刷新设置
        [self.tableView.mj_header endRefreshing];
        if (temArr.count == listShowCount) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //刷新
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForTopCarList {
    self.tableView.page = 1;
    [self dataRequest];
}

-(void)requestForTopCarListBottom {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"top_car_list",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"local_state":@"1",@"flag":@"1",@"page_no":@"1",@"page_size":@"20"} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self.botSourceArray removeAllObjects];
        [self.botSourceArray addObjectsFromArray:[[response objectForKey:@"result_info"] objectForKey:@"car_list"]];
        
        self.collectionView.dataArr = self.botSourceArray;
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - action
//降价确认
- (void)confirmBtnClick:(UIButton *)sender {
    if([NSString isEmptyString:self.priceView.textField.text])
    {
        [MBProgressHUD showError:@"请输入降价金额"];
        return;
    }
    if(![NSString isDigitalCharacters:self.priceView.textField.text])
    {
        [MBProgressHUD showError:@"请输入正确的金额"];
        return;
    }
    NSString *explan = @"";
    if(![NSString isEmptyString:self.priceView.txtView.text])
    {
        explan = self.priceView.txtView.text;
    }
    
    NSDictionary *dic = [self.sourceArray objectAtIndex:self.currentAddIndex];

    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"add_car_flag",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"business_car_id":[dic objectForKey:@"business_car_id"],@"car_id":[dic objectForKey:@"id"],@"flag":@"1",@"explain":explan,@"wholesale_price_old":[[dic objectForKey:@"wholesale_price"] stringValue],@"wholesale_price":self.priceView.textField.text} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        
        [self requestForTopCarList];
        [self requestForTopCarListBottom];
        [self.priceView hidden];
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForDelete:(NSInteger)btnTag
{
    NSDictionary *dic = [self.botSourceArray objectAtIndex:self.currentAddIndex];

    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"update_car_flag",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"business_car_id":[dic objectForKey:@"business_car_id"],@"flag":@"0"} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self requestForTopCarList];
        [self requestForTopCarListBottom];
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

//添加头条车辆
- (void)addBtnClick:(UIButton *)sender {
    self.currentAddIndex = sender.tag;
    NSDictionary *dic = [self.sourceArray objectAtIndex:sender.tag];
    self.priceView.tradePriceLB.text = [NSString stringWithFormat:@"原批发：%@万",[[QLToolsManager share] unitMileage:[[dic objectForKey:@"wholesale_price"] floatValue]]];
    self.priceView.txtView.text = [[dic objectForKey:@"business_car"] objectForKey:@"explain"];
    [self.priceView show];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.extendDelegate = self;
    self.tableView.showHeadRefreshControl = YES;
    self.tableView.showFootRefreshControl = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLEditTopCarCell" bundle:nil] forCellReuseIdentifier:@"editTopCarCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.collectionView.mas_top);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sourceArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLEditTopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editTopCarCell" forIndexPath:indexPath];
    cell.addBtn.tag = indexPath.row;
    [cell.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *dic = [self.sourceArray objectAtIndex:indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"car_img"]]];
    cell.titleLB.text = [dic objectForKey:@"model"];
    cell.priceLB.text = [NSString stringWithFormat:@"批发%@万",[[QLToolsManager share] unitMileage:[[dic objectForKey:@"wholesale_price"] floatValue]]];
    cell.salePriceLB.text = [NSString stringWithFormat:@"零售价%@万",[[QLToolsManager share] unitMileage:[[dic objectForKey:@"sell_price"] floatValue]]];

    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    
    UILabel *titleLB = [UILabel new];
    titleLB.font = [UIFont systemFontOfSize:13];
    titleLB.textColor = [UIColor lightGrayColor];
    titleLB.text = @"发布头条车源到首页,提高成交率";
    [headerView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView).offset(20);
    }];
    
    UILabel *numLB = [UILabel new];
    numLB.font = [UIFont systemFontOfSize:13];
    numLB.textColor = GreenColor;
    numLB.text = [NSString stringWithFormat:@"最多选%d辆",3];
    [headerView addSubview:numLB];
    [numLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.right.equalTo(headerView).offset(-15);
    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLEditTopCarItem class]]) {
        QLEditTopCarItem *item = (QLEditTopCarItem *)baseCell;
        item.deleteBtn.tag = indexPath.row;
        [item setTapBlock:^(UIButton * _Nonnull delBtn) {
            [[QLToolsManager share] alert:@"确认要下架头条？" handler:^(NSError *error) {
                if(!error)
                {
                    [self requestForDelete:delBtn.tag];
                }
            }];
        }];
        NSDictionary *dic = [self.botSourceArray objectAtIndex:indexPath.row];
        [item.imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"car_img"]]];
        item.titleLB.text = [dic objectForKey:@"model"];
    }
}

#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLItemModel *model = [QLItemModel new];
        model.sectionInset = UIEdgeInsetsMake(8, 16, 12, 0);
        model.Spacing = QLMinimumSpacingMake(10, 10);
        model.rowCount = 1;
        model.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        model.itemName = @"QLEditTopCarItem";
        model.itemSize = CGSizeMake(115, 120);
        
        _collectionView = [[QLBaseCollectionView alloc] initWithFrame:CGRectZero ItemModel:model];
        _collectionView.extendDelegate = self;
        [_collectionView setShadowPathWith:[UIColor groupTableViewBackgroundColor] shadowOpacity:1 shadowRadius:1 shadowSide:QLShadowPathAllSide shadowPathWidth:1];
    }
    return _collectionView;
}
- (QLEditTopPriceView *)priceView {
    if (!_priceView) {
        _priceView = [QLEditTopPriceView new];
        [_priceView.confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceView;
}
@end
