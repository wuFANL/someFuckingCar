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
#import "QLMyHelpSellViewController.h"
#import "QLDistributionOrderViewController.h"
#import "QLTransactionSubmitViewController.h"
#import "QLCarLicenseViewController.h"
#import "QLCarSourceDetailViewController.h"

@interface QLChatListPageViewController ()<QLBaseCollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, assign) NSInteger chooseTypeIndex;
@property (nonatomic, strong) QLChatBottomView *bottomView;

@property (nonatomic, strong) NSString *friendPhone;
@property (nonatomic, strong) NSMutableArray *topArray;
@property (nonatomic, strong) NSMutableArray *chatListArray;
@property (nonatomic, strong) NSDictionary *currentDic;
@property (nonatomic, strong) NSString *currentID;

//首次进入的carID 和对方的ID
@property (nonatomic, copy) NSString *firstCarId;
@property (nonatomic, copy) NSString *firstFriendId;
@property (nonatomic, strong) NSMutableDictionary *firstInDic;
@end

@implementation QLChatListPageViewController

-(id)initWithCarID:(NSString*)carID messageToID:(NSString *)messageTo
{
    self = [super init];
    if(self)
    {
        self.firstCarId = carID;
        self.firstFriendId = messageTo;
        self.topArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.chatListArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.firstInDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

-(void)requestForMsgSendJY:(NSString *)content PriceStr:(NSString *)price
{
    NSDictionary *dic = @{@"operation_type":@"chat_send",
                            @"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,
                            @"account_id":self.firstFriendId,
                            @"car_id":[self.currentDic objectForKey:@"id"]?:@"",@"car_send":@"0",
                            @"content":content,@"m_type":@"4",@"status":@"0",
                            @"price":price
    };
    [self requestForMsgSendWithDic:dic];
}
-(void)requestForMsgSendHZ:(NSString *)content PriceStr:(NSString *)price
{
    NSDictionary *dic = @{@"operation_type":@"chat_send",
                            @"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,
                            @"account_id":self.firstFriendId,
                            @"car_id":[self.currentDic objectForKey:@"id"]?:@"",@"car_send":@"0",
                            @"content":content,@"m_type":@"5",@"status":@"0",
                            @"price":price
    };
    [self requestForMsgSendWithDic:dic];
}
-(void)requestForMsgSendText:(NSString *)chatMsg
{
    NSDictionary *dic = @{@"operation_type":@"chat_send",
                            @"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,
                            @"account_id":self.firstFriendId,
                            @"car_id":[self.currentDic objectForKey:@"id"]?:@"",@"car_send":@"0",
                            @"content":chatMsg,@"m_type":@"1",@"status":@"1",
                            @"t_id":[self.currentDic objectForKey:@"t_id"],
    };
    [self requestForMsgSendWithDic:dic];
}
-(void)requestForMsgSendImage:(NSString *)imageUrl
{
    NSDictionary *dic = @{@"operation_type":@"chat_send",
                            @"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,
                            @"account_id":self.firstFriendId,
                            @"car_id":[self.currentDic objectForKey:@"id"]?:@"",
                            @"car_send":@"0",
                            @"file_url":imageUrl,
                            @"content":@"图片",@"m_type":@"2",@"status":@"1",
                            @"t_id":[self.currentDic objectForKey:@"t_id"],
    };
    [self requestForMsgSendWithDic:dic];
}

-(void)requestForMsgSendWithDic:(NSDictionary *)params
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:params success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self dataRequest];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForChatTop
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"chat_top",@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"account_id":self.firstFriendId,@"car_id":self.firstCarId?:@""} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self.firstInDic removeAllObjects];
        [self.firstInDic addEntriesFromDictionary:[response objectForKey:@"result_info"]];
        
        self.friendPhone = [[[response objectForKey:@"result_info"] objectForKey:@"user_info"] objectForKey:@"mobile"];
        [self.topArray removeAllObjects];
        [self.topArray addObjectsFromArray:[[response objectForKey:@"result_info"] objectForKey:@"all_car_list"]];
        self.collectionView.dataArr = [self.topArray mutableCopy];
        if([self.collectionView.dataArr count] > 0)
        {
            self.currentDic = [[self.collectionView.dataArr firstObject] copy];
            [self requestForChatList:[self.collectionView.dataArr firstObject]];
            [self requestForIsMyCar];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForAgreeOrCancel:(NSString *)msg_id btnTag:(NSInteger)tag
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:TradePath params:@{@"operation_type":@"is_msg_agree",@"status":tag==0?@"-1":@"1",@"msg_id":msg_id} success:^(id response) {
        [self dataRequest];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}


- (void)dataRequest
{
    if(self.currentDic)
    {
        [self requestForChatList:self.currentDic];
    }
}

-(void)requestForChatList:(NSDictionary *)dic
{
    if(![[dic objectForKey:@"id"] isEqualToString:self.currentID])
    {
        self.tableView.page = 1;
    }
    self.currentID = [dic objectForKey:@"id"];
    [QLNetworkingManager postWithUrl:FirendPath params:@{@"operation_type":@"chat_page_list",@"my_account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"account_id":self.firstFriendId,@"trade_id":[dic objectForKey:@"t_id"],@"car_id":[dic objectForKey:@"id"],@"flag":@"1",@"page_no":@(self.tableView.page),@"page_size":@"20"} success:^(id response) {
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:self.chatListArray.count-1];
            [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
        
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

-(void)requestForIsMyCar
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"query_car_local_state",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"car_id":[self.currentDic objectForKey:@"id"]?:@""} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
//        返1 是我的车辆 有 交易 图片 车证 联系
//        不是我的车辆
//        返-1有 交易 图片 联系 加入帮卖
//        返2有 交易 图片 联系 取消帮卖
        NSString *result = [[response objectForKey:@"result_info"] objectForKey:@"result"];
        if([result isEqualToString:@"-1"])
        {
            self.bottomView.funArr = @[@"交易",@"图片",@"联系",@"加入帮卖"];
        }
        else if ([result isEqualToString:@"2"])
        {
            self.bottomView.funArr = @[@"交易",@"图片",@"联系",@"取消帮卖"];
        }
        else
        {
            self.bottomView.funArr = @[@"交易",@"图片",@"车证",@"联系"];
        }

    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}

- (void)actionGoToCarDetail {
    NSDictionary *carInfoData = @{
        //    account_id    对方用户id
        @"account_id":self.firstFriendId?:@"",
        //    car_id        车辆id model_id
        @"car_id":[self.currentDic objectForKey:@"id"]?:@""};
    QLCarSourceDetailViewController *csdVC = [QLCarSourceDetailViewController new];
    csdVC.isFromChat = YES;
    [csdVC updateVcWithData:carInfoData];
    [self.navigationController pushViewController:csdVC animated:YES];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JPushNotifForChatMessage:) name:@"JPushNotifForChatMessage" object:nil];
    
    [self requestForChatTop];
}

-(void)JPushNotifForChatMessage:(NSNotification *)notif
{
    [self dataRequest];
}

#pragma mark - action
//帮卖订单
- (void)rightItemClick {
    QLMyHelpSellViewController *hsVC = [QLMyHelpSellViewController new];
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
    self.tableView.extendDelegate = self;
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
    cell.sourceDic = dic;

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
    [cell setTapCarBlock:^{
        //纯文本按钮点击
        [self actionGoToCarDetail];
    }];
    [cell setAOrcBlock:^(NSInteger tag, NSString * _Nonnull msg_id) {
        [self requestForAgreeOrCancel:msg_id btnTag:tag];
    }];
    [cell showMsgBtnWithDic:dic];
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
    self.currentDic = [[self.topArray objectAtIndex:indexPath.row] copy];
    [self requestForChatList:[self.topArray objectAtIndex:indexPath.row]];
    [self requestForIsMyCar];
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
        WEAKSELF
        [_bottomView setMsgBlock:^(NSString * _Nonnull MsgText) {
            [weakSelf requestForMsgSendText:MsgText];
        }];
        _bottomView.clickHandler = ^(id result, NSError *error) {
            NSString *funName = result;
            if ([funName isEqualToString:@"交易"]) {
                QLCustomSheetView *sheetView = [QLCustomSheetView new];
                sheetView.listArr = @[@"发送交易合同",@"合作出售"];
                sheetView.clickHandler = ^(id result, NSError *error) {
                    NSInteger index = [result integerValue];
                    if (index != -1) {
                        QLTransactionSubmitViewController *tsVC = [[QLTransactionSubmitViewController alloc] initWithSourceDic:weakSelf.currentDic];
                        [tsVC setMsBlock:^(NSString * _Nonnull price, NSString * _Nonnull content) {
                            if(index == 0)
                            {
                                [weakSelf requestForMsgSendJY:content PriceStr:price];
                            }
                            else
                            {
                                [weakSelf requestForMsgSendHZ:content PriceStr:price];

                            }
                        }];
                        tsVC.type = index==0?TransactionContract:CooperativeTransaction;
                        tsVC.showDesc = YES;
                        [weakSelf.navigationController pushViewController:tsVC animated:YES];
                    }
                };
                [sheetView show];
            } else if ([funName isEqualToString:@"图片"]) {
                [[QLToolsManager share] getPhotoAlbum:weakSelf resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
                    UIImage *img = info[UIImagePickerControllerOriginalImage];
                    [[QLOSSManager shared] asyncUploadImage:img complete:^(NSArray *names, UploadImageState state) {
                        [MBProgressHUD immediatelyRemoveHUD];
                        if (state == UploadImageSuccess) {
                            [weakSelf requestForMsgSendImage:[names firstObject]];
                        } else {
                            [MBProgressHUD showError:@"图片上传失败"];
                        }
                    }];
                }];
            } else if ([funName isEqualToString:@"车证"]) {
                QLCarLicenseViewController *clVC = [QLCarLicenseViewController new];
                [weakSelf.navigationController pushViewController:clVC animated:YES];
            } else if ([funName isEqualToString:@"派单"]) {
                QLDistributionOrderViewController *doVC = [QLDistributionOrderViewController new];
                [weakSelf.navigationController pushViewController:doVC animated:YES];
            }
            else if ([funName isEqualToString:@"联系"]) {
                [[QLToolsManager share] contactCustomerService:weakSelf.friendPhone];
            }
            else if ([funName containsString:@"帮卖"]) {
                [weakSelf requestForSelectedCar];
            }
            
        };
    }
    return _bottomView;
}
     
-(void)requestForSelectedCar
{
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:BusinessPath params:@{@"operation_type":@"select_car",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"business_id":[self.currentDic objectForKey:@"business_id"],@"car_ids":[self.currentDic objectForKey:@"id"],@"state":@"1"} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self requestForIsMyCar];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];

    
}
     
@end
