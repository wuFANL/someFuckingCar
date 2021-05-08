//
//  QLChatListPageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/4.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLChatListPageViewController.h"
#import "QLChatListHeadItem.h"
#import "QLChatMsgCell.h"
#import "QLChatBottomView.h"
#import "QLCustomSheetView.h"
#import "QLHelpSellViewController.h"
#import "QLDistributionOrderViewController.h"
#import "QLTransactionSubmitViewController.h"
#import "QLCarLicenseViewController.h"

@interface QLChatListPageViewController ()<QLBaseCollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, assign) NSInteger chooseTypeIndex;
@property (nonatomic, strong) QLChatBottomView *bottomView;

@property (nonatomic, strong) MessageDetailModel *detlModel;
@property (nonatomic, strong) NSMutableArray *topArray;
@property (nonatomic, strong) NSMutableArray *chatListArray;
@property (nonatomic, strong) NSDictionary *currentDic;
@property (nonatomic, strong) NSString *currentID;
@end

@implementation QLChatListPageViewController

-(id)initWithMessageDetailModel:(MessageDetailModel *)detailModel
{
    self = [super init];
    if(self)
    {
        self.detlModel = detailModel;
        self.topArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.chatListArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(void)requestForChatTop
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"chat_top",@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"account_id":[[self.detlModel.tradeInfo objectForKey:@"buyer_info"] objectForKey:@"account_id"],@"car_id":[self.detlModel.tradeInfo objectForKey:@"car_id"]?:@""} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];

        [self.topArray removeAllObjects];
        [self.topArray addObjectsFromArray:[[response objectForKey:@"result_info"] objectForKey:@"all_car_list"]];
        self.collectionView.dataArr = [self.topArray mutableCopy];
        if([self.collectionView.dataArr count] > 0)
        {
            [self requestForChatList:[self.collectionView.dataArr firstObject]];
            self.currentDic = [[self.collectionView.dataArr firstObject] copy];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)dataRequest
{
    [self requestForChatList:self.currentDic];
}

-(void)requestForChatList:(NSDictionary *)dic
{
    if(![[dic objectForKey:@"id"] isEqualToString:self.currentID])
    {
        self.tableView.page = 1;
    }
    self.currentID = [dic objectForKey:@"id"];
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"chat_page_list",@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"account_id":[[self.detlModel.tradeInfo objectForKey:@"buyer_info"] objectForKey:@"account_id"],@"trade_id":[dic objectForKey:@"t_id"],@"car_id":[dic objectForKey:@"id"],@"flag":@"1",@"page_no":@(self.tableView.page),@"page_size":@"20"} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];

        if (self.tableView.page == 1) {
            [self.chatListArray removeAllObjects];
        }
        NSArray *temArr = [NSArray arrayWithArray:[[response objectForKey:@"result_info"] objectForKey:@"detail_list"]];
        [self.chatListArray addObjectsFromArray:temArr];
        //无数据设置
        if (self.chatListArray.count == 0) {
            self.tableView.hidden = YES;
            self.showNoDataView = YES;
        } else {
            self.tableView.hidden = NO;
            self.showNoDataView = NO;
        }
        //刷新设置
        [self.tableView.mj_header endRefreshing];
        if (temArr.count == 20) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"helpMallNaviIcon"] originalImage] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //collectionView
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(88);
    }];

    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(105);
    }];
    //tableView
    [self tableViewSet];
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    [self requestForChatTop];
}

#pragma mark - action
//帮卖订单
- (void)rightItemClick {
    QLHelpSellViewController *hsVC = [QLHelpSellViewController new];
    [self.navigationController pushViewController:hsVC animated:YES];
}
//键盘将要 升起 的通知
-(void)openKeyBoard:(NSNotification*)notification {
    //获取动画的种类
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //获取动画时长
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //获取键盘的尺寸
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //添加修改约束 并加动画
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-keyboardFrame.size.height);
        }];
        [self.view layoutIfNeeded];
    } completion:nil];
    
}
//键盘将要 回去 的通知
-(void)closeKeyBoard:(NSNotification*)notification {
    //获取动画的种类
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //获取动画时长
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //添加修改约束 并加动画
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        }];
        [self.view layoutIfNeeded];
    } completion:nil];
}
- (BOOL)keyboardManagerEnabled {
    return NO;
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLChatMsgCell" bundle:nil] forCellReuseIdentifier:@"chatMsgCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    self.tableView.showHeadRefreshControl = YES;
    self.tableView.showFootRefreshControl = YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.chatListArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLChatMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatMsgCell" forIndexPath:indexPath];
    
    NSDictionary *dic = [self.chatListArray objectAtIndex:indexPath.section];
    [cell.aHeadImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"from_head_pic"]]];
    NSString *mtype = [dic objectForKey:@"m_type"];
    if([mtype isEqualToString:@"1"] || [mtype isEqualToString:@"3"] || [mtype isEqualToString:@"6"]) {
        cell.msgType = TextMsg;
    } else if([mtype isEqualToString:@"2"]) {
        cell.msgType = ImgMsg;
    } else {
        cell.msgType = AskMsg;
    }
    //内容
    if([[QLUserInfoModel getLocalInfo].account.account_id isEqualToString:[dic objectForKey:@"from_account_id"]])
    {
        //我发别人
        cell.msgReceiver = MyMsg;
    }
    else
    {
        //别人发给我
        cell.msgReceiver = OtherMsg;
    }

    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    NSDictionary *dic = [self.chatListArray objectAtIndex:section];
    UILabel *lb = [UILabel new];
    lb.textColor = [UIColor colorWithHexString:@"#999999"];
    lb.font = [UIFont systemFontOfSize:13];
    lb.text = [dic objectForKey:@"create_time"];
    [headerView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
    }];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLChatListHeadItem class]]) {
        NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
        QLChatListHeadItem *item = (QLChatListHeadItem *)baseCell;
        [item showBadge:[dic objectForKey:@"msg_count"]];
        [item.imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"car_img"]]];
        NSString *belonger = [dic objectForKey:@"belonger"];
        NSString *t_id = [dic objectForKey:@"t_id"];
        item.iconBtn.hidden = NO;
        if([belonger isEqualToString:[QLUserInfoModel getLocalInfo].account.account_id]) {
            [item.iconBtn setTitle:@"我的" forState:UIControlStateNormal];
        } else {
            if([t_id intValue] > 0) {
                [item.iconBtn setTitle:@"洽谈" forState:UIControlStateNormal];
            } else {
                item.iconBtn.hidden = YES;
            }
        }
        [item.imgView roundRectCornerRadius:2 borderWidth:3 borderColor:indexPath.row == self.chooseTypeIndex?GreenColor:ClearColor];
    }
}
-(void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    self.chooseTypeIndex = indexPath.row;
    [self requestForChatList:[self.topArray objectAtIndex:indexPath.row]];
    self.currentDic = [[self.topArray objectAtIndex:indexPath.row] copy];
    [collectionView reloadData];
}
#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLItemModel *model = [QLItemModel new];
        model.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        model.sectionInset = UIEdgeInsetsMake(15, 12, 15, 0);
        model.Spacing = QLMinimumSpacingMake(10, 10);
        model.rowCount = 1;
        
        CGFloat width = (self.view.width-15-(model.Spacing.minimumLineSpacing*3))/4;
        model.itemSize = CGSizeMake(width, 58);
        model.itemName = @"QLChatListHeadItem";
        
        _collectionView = [[QLBaseCollectionView alloc] initWithFrame:CGRectZero ItemModel:model];
        _collectionView.extendDelegate = self;
        
    }
    return _collectionView;
}
- (QLChatBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLChatBottomView new];
        _bottomView.funArr = @[@"交易",@"图片",@"车证",@"派单",@"联系",@"加入帮卖"];
        WEAKSELF
        _bottomView.clickHandler = ^(id result, NSError *error) {
            NSString *funName = result;
            if ([funName isEqualToString:@"交易"]) {
                QLCustomSheetView *sheetView = [QLCustomSheetView new];
                sheetView.listArr = @[@"发送交易合同",@"合作出售"];
                sheetView.clickHandler = ^(id result, NSError *error) {
                    NSInteger index = [result integerValue];
                    if (index != -1) {
                        QLTransactionSubmitViewController *tsVC = [QLTransactionSubmitViewController new];
                        tsVC.type = index==0?TransactionContract:CooperativeTransaction;
                        tsVC.showDesc = YES;
                        [weakSelf.navigationController pushViewController:tsVC animated:YES];
                    }
                };
                [sheetView show];
            } else if ([funName isEqualToString:@"图片"]) {
                [[QLToolsManager share] getPhotoAlbum:weakSelf resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
                    UIImage *img = info[UIImagePickerControllerOriginalImage];
                   
                }];
            } else if ([funName isEqualToString:@"车证"]) {
                QLCarLicenseViewController *clVC = [QLCarLicenseViewController new];
                [weakSelf.navigationController pushViewController:clVC animated:YES];
            } else if ([funName isEqualToString:@"派单"]) {
                QLDistributionOrderViewController *doVC = [QLDistributionOrderViewController new];
                [weakSelf.navigationController pushViewController:doVC animated:YES];
            }
            
        };
    }
    return _bottomView;
}
@end
