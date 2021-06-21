//
//  QLCarCircleViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/16.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarCircleViewController.h"
#import "QLCarCircleNaviView.h"
#import "QLCarCircleHeadView.h"
#import "QLCarCircleUnreadView.h"
#import "QLCarCircleTextCell.h"
#import "QLCarCircleImgCell.h"
#import "QLCarCircleAccCell.h"
#import "QLCarCircleLikeCell.h"
#import "QLCarCircleCommentCell.h"
#import "QLCarCircleAccMoreView.h"
#import "QLDynamicSendMsgBottomView.h"
#import "QLReleaseCarCircleViewController.h"
#import "QLUnreadMsgListViewController.h"
#import "QLContactsInfoViewController.h"
#import "QLRidersDynamicListModel.h"

@interface QLCarCircleViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseTableViewDelegate,QLBannerViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) QLCarCircleNaviView *naviView;
@property (nonatomic, strong) QLCarCircleHeadView *headView;
@property (nonatomic, strong) QLCarCircleUnreadView *unreadView;
@property (nonatomic, strong) QLCarCircleAccMoreView *accView;
@property (nonatomic, strong) QLDynamicSendMsgBottomView *bottomView;

@property (nonatomic, strong) NSDictionary *msgDic;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) BOOL isEditAnimation;
@end

@implementation QLCarCircleViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.showHeadRefreshControl = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44+(BottomOffset?44:20));
    }];
    //发送栏
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(0);
    }];

    //tableView
    [self tableViewSet];
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    
}
#pragma mark - network
//最新消息
- (void)lastMsgRequest {
    [QLNetworkingManager postWithUrl:DynamicPath params:@{@"operation_type":@"to_read/count",@"account_id":([QLUserInfoModel getLocalInfo].account.account_id)} success:^(id response) {
        self.msgDic = [response objectForKey:@"result_info"];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
//列表
- (void)dataRequest {
    if (self.tableView.page == 1) {
        //车友圈最新消息
        [self lastMsgRequest];
    }
    [QLNetworkingManager postWithUrl:DynamicPath params:@{@"operation_type":@"all_page_list",@"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id),@"page_no":@(self.tableView.page),@"page_size":@(listShowCount)} success:^(id response) {
        if (self.tableView.page == 1) {
            [self.listArray removeAllObjects];
        }
        NSArray *temArr = [NSArray yy_modelArrayWithClass:[QLRidersDynamicListModel class] json:response[@"result_info"][@"dynamic_list"]];
        [self.listArray addObjectsFromArray:temArr];
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

//点赞
- (void)likeRequest:(BOOL)isLike {
    QLRidersDynamicListModel *model = self.listArray[self.accView.tag];
    NSString *operation_type = isLike?@"praise/add":@"praise/remove";
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:DynamicPath params:@{@"operation_type":operation_type,@"dynamic_id":model.dynamic_id,@"account_id":[QLUserInfoModel getLocalInfo].account.account_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        if (isLike) {
            QLRidersDynamicPraiseModel *praiseModel = [QLRidersDynamicPraiseModel new];
            praiseModel.account_id = [QLUserInfoModel getLocalInfo].account.account_id;
            praiseModel.account_name = [QLUserInfoModel getLocalInfo].account.nickname;
            model.praise_list = [model.praise_list arrayByAddingObject:praiseModel];
        } else {
            NSMutableArray *temArr = [NSMutableArray arrayWithArray:model.praise_list];
            [temArr enumerateObjectsUsingBlock:^(QLRidersDynamicPraiseModel * _Nonnull praiseModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([praiseModel.account_id isEqualToString:[QLUserInfoModel getLocalInfo].account.account_id]) {
                    [temArr removeObject:praiseModel];
                }
            }];
            model.praise_list = temArr;
        }
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
//发送评论
- (void)sendMsgRequest:(NSString *)to_account_id {
    QLRidersDynamicListModel *model = self.listArray[self.bottomView.tag];
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:DynamicPath params:@{@"operation_type":@"interact/add",@"dynamic_id":model.dynamic_id,@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"to_account_id":to_account_id,@"content":QLNONull(self.bottomView.tf.text)} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
    
        QLRidersDynamicInteractModel *interactModel = [QLRidersDynamicInteractModel new];
        interactModel.account_id = [QLUserInfoModel getLocalInfo].account.account_id;
        interactModel.account_name = [QLUserInfoModel getLocalInfo].account.nickname;
        if (to_account_id.length != 0 && ![to_account_id isEqualToString:interactModel.account_id]) {
            interactModel.to_account_id = to_account_id;
            interactModel.to_account_name = self.bottomView.receiverName;
        }
        
        interactModel.content = self.bottomView.tf.text;
        model.interact_list = [model.interact_list arrayByAddingObject:interactModel];
        
        self.bottomView.tf.text = @"";
        [self bottomViewShowStatus:NO];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
//删除动态
- (void)deleteRequest:(QLRidersDynamicListModel *)model {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:DynamicPath params:@{@"operation_type":@"remove",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"dynamic_id":model.dynamic_id} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        [self.listArray removeObject:model];
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
//改背景
- (void)changeBjRequest:(NSString *)back_pic {
    [QLNetworkingManager postWithUrl:UserPath params:@{@"operation_type":@"update_account",@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"back_pic":back_pic} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        QLUserInfoModel *model = [QLUserInfoModel getLocalInfo];
        model.account.back_pic = back_pic;
        [QLUserInfoModel updateUserInfoByModel:model];
        
        self.headView.bannerView.imagesArr = @[[QLUserInfoModel getLocalInfo].account.back_pic];
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - action

//发送
- (void)sendBtnClick {
    if (self.bottomView.tf.text.length == 0) {
        return;
    }
    
    [self sendMsgRequest:([self.bottomView.msgAccountId isEqualToString:self.bottomView.receiverAccountId]||[self.bottomView.sendAccountId isEqualToString:self.bottomView.receiverAccountId])?@"":self.bottomView.receiverAccountId];
}
//评论
- (void)commentBtnClick:(UIButton *)sender {
    [self.accView hidden];
    NSInteger section = self.accView.tag;
    QLRidersDynamicListModel *model = self.listArray[section];
    self.bottomView.tag = section;
    self.bottomView.msgAccountId = model.account_id;
    self.bottomView.sendAccountId = [QLUserInfoModel getLocalInfo].account.account_id;
    self.bottomView.sendAccountName = [QLUserInfoModel getLocalInfo].account.nickname;
    self.bottomView.receiverAccountId = model.account_id;
    self.bottomView.receiverName = model.account_nickname;
    self.bottomView.tf.placeholder = @"评论";
    [self bottomViewShowStatus:YES];
    //滚动到评论数据
    self.isEditAnimation = YES;
    NSInteger totalCellNum = [self.tableView numberOfRowsInSection:section];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:totalCellNum-1 inSection:section];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
//赞
- (void)likeBtnClick:(UIButton *)sender {
    [self.accView hidden];
    NSString *currentTitle = sender.currentTitle;
    [self likeRequest:[currentTitle isEqualToString:@"赞"]?YES:NO];
}
//动态更多
- (void)moreOpenBtnClick:(UIButton *)sender {
    [self.accView removeFromSuperview];
    
    NSInteger section = sender.tag;
    QLRidersDynamicListModel *model = self.listArray[section];
    NSString *myAccountId;
    for (QLRidersDynamicPraiseModel *praiseModel in model.praise_list) {
        if ([praiseModel.account_id isEqualToString:[QLUserInfoModel getLocalInfo].account.account_id]) {
            myAccountId = praiseModel.account_id;
        }
    }
    
    self.accView.tag = section;
    [self.accView.likeBtn setTitle:myAccountId.length==0?@"赞":@"撤销点赞" forState:UIControlStateNormal];
    self.accView.hidden = YES;
    [self.view addSubview:self.accView];
    [UIView animateWithDuration:0.01 animations:^{
        [self.accView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.left.equalTo(sender);
        }];
    } completion:^(BOOL finished) {
        self.accView.hidden = NO;
        [UIView animateWithDuration:animationDuration animations:^{
            [self.accView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(sender).offset(-170);
            }];
            [self.view layoutIfNeeded];
        }];
    }];
    
    
}
//底部变化
- (void)bottomViewShowStatus:(BOOL)isShow {
    self.bottomView.hidden = !isShow;
    if (isShow) {
        [self.bottomView.tf becomeFirstResponder];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(45);
        }];
    } else {
        [self.view endEditing:YES];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}
//删除动态
- (void)deleteMsgClick:(UIButton *)sender {
    [[QLToolsManager share] alert:@"是否确认删除动态？" handler:^(NSError *error) {
        if (!error) {
            NSInteger section = sender.tag;
            QLRidersDynamicListModel *model = self.listArray[section];
            [self deleteRequest:model];
        }
    }];
    
}
//发布动态
- (void)funBtnClick {
    QLReleaseCarCircleViewController *rccVC = [QLReleaseCarCircleViewController new];
    [self.navigationController pushViewController:rccVC animated:YES];
}
//未读消息点击
- (void)unreadMsgControlClick {
    QLUnreadMsgListViewController *umlVC = [QLUnreadMsgListViewController new];
    [self.navigationController pushViewController:umlVC animated:YES];
}
//轮播图设置
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn {
    [imageBtn sd_setImageWithURL:[NSURL URLWithString:imageArr[index]] forState:UIControlStateNormal];
    
}
//轮播图点击
- (void)bannerView:(QLBannerView *)bannerView ImageClick:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn {
    [[QLToolsManager share] getPhotoAlbum:self resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        if (img) {
            [MBProgressHUD showCustomLoading:nil];
            [[QLOSSManager shared] asyncUploadImage:img complete:^(NSArray *names, UploadImageState state) {
                [self changeBjRequest:names.firstObject];
            }];
        } else {
            [MBProgressHUD showError:@"未获取到图片"];
        }
    }];
}
//去店铺
- (void)goStoreClick:(UIButton *)sender {
    NSInteger index = sender.tag;
    
    NSString *friendId;
    if (index == -1) {
        friendId = [QLUserInfoModel getLocalInfo].account.account_id;
    } else {
        QLRidersDynamicListModel *model = self.listArray[index];
        friendId = model.account_id;
    }
    QLContactsInfoViewController *ciVC = [[QLContactsInfoViewController alloc] initWithFirendID:friendId];
    ciVC.contactRelation = Friend;
    [self.navigationController pushViewController:ciVC animated:YES];
}
//返回
- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
//键盘弹起
-(void)openKeyBoard:(NSNotification*)notification {
    //获取动画的种类
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //获取动画时长
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //获取键盘的尺寸
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //添加修改约束 并加动画
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyboardFrame.size.height);
    }];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
}
//键盘关闭
-(void)closeKeyBoard:(NSNotification*)notification {
    //获取动画的种类
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //获取动画时长
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //添加修改约束 并加动画
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
    }];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}
//页面点击
- (void)tapClick:(UIGestureRecognizer *)gesture {
    [self.view endEditing:YES];
    [self.accView hidden];
    [self bottomViewShowStatus:NO];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    } else if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIImageView"]) {
        return NO;
    } else if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIControl"]) {
        return NO;
    }
    return YES;
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.extendDelegate = self;
    self.tableView.showFootRefreshControl = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleImgCell" bundle:nil] forCellReuseIdentifier:@"imgCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleAccCell" bundle:nil] forCellReuseIdentifier:@"accCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleLikeCell" bundle:nil] forCellReuseIdentifier:@"likeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleCommentCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    //tableHeaderView
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 250)];
    [tableHeaderView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableHeaderView);
    }];
    self.tableView.tableHeaderView = tableHeaderView;
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.listArray.count > 0) {
        NSInteger row = 2;
        QLRidersDynamicListModel *model = self.listArray[section];
        if (model.file_array.count != 0) {
            row++;
        }
        if (model.praise_list.count != 0) {
            row++;
        }
        if (model.interact_list.count != 0) {
            row++;
        }
        return row;
    }
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLRidersDynamicListModel *model = self.listArray[indexPath.section];
    if (indexPath.row == 0) {
        QLCarCircleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.likeBtn.hidden = YES;
        cell.textLBLeft.constant = 0;
        cell.headBtn.tag = indexPath.section;
        [cell.headBtn addTarget:self action:@selector(goStoreClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.model = model;
        return cell;
    } else if (indexPath.row == 1&&model.file_array.count != 0) {
        QLCarCircleImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imgCell" forIndexPath:indexPath];
        cell.dataType = ImageType;
        cell.dataArr = [model.file_array mutableCopy];
        return cell;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-(model.interact_list.count != 0?2:1)&&model.praise_list.count != 0) {
        QLCarCircleLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"likeCell" forIndexPath:indexPath];
        cell.dataArr = model.praise_list;
        return cell;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1&&model.interact_list.count != 0) {
        QLCarCircleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
        cell.listArr = model.interact_list;
        cell.clickHandler = ^(id result, NSError *error) {
            QLRidersDynamicInteractModel *interactModel = result;
            
            self.bottomView.tag = indexPath.section;
            self.bottomView.msgAccountId = model.account_id;
            
            self.bottomView.sendAccountId = [QLUserInfoModel getLocalInfo].account.account_id;
            self.bottomView.sendAccountName = [QLUserInfoModel getLocalInfo].account.nickname;
            self.bottomView.receiverAccountId = interactModel.account_id;
            self.bottomView.receiverName = interactModel.account_name;
            self.bottomView.tf.placeholder = [self.bottomView.sendAccountId isEqualToString:self.bottomView.receiverAccountId]||self.bottomView.receiverAccountId.length == 0?@"评论":[NSString stringWithFormat:@"回复：%@",interactModel.account_name];
            [self bottomViewShowStatus:YES];
            
        };
        return cell;
    } else {
        QLCarCircleAccCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accCell" forIndexPath:indexPath];
        cell.deleteBtn.tag = indexPath.section;
        cell.moreOpenBtn.tag = indexPath.section;
        cell.accLB.text = [NSString stringWithFormat:@"%@  %@",model.address,[QLToolsManager compareCurrentTime:model.create_time]];
        cell.deleteBtn.hidden = [model.account_id isEqualToString:[QLUserInfoModel getLocalInfo].account.account_id]?NO:YES;
        [cell.deleteBtn addTarget:self action:@selector(deleteMsgClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.moreOpenBtn addTarget:self action:@selector(moreOpenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *toreadcount = [self.msgDic objectForKey:@"to_read_count"];
    if (section == 0&&[toreadcount integerValue] != 0) {
        NSString *head = [self.msgDic objectForKey:@"head_pic"];
        [self.unreadView.headBtn sd_setImageWithURL:[NSURL URLWithString:head] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultHead"]];
        self.unreadView.numMsgLB.text = [NSString stringWithFormat:@"%@条新消息",toreadcount];
        return self.unreadView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *toreadcount = [self.msgDic objectForKey:@"to_read_count"];
    return section == 0&&[toreadcount integerValue] != 0?80:15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isEditAnimation == NO) {
        [self.accView hidden];
        [self bottomViewShowStatus:NO];
    } else {
        self.isEditAnimation = NO;
    }
    
}
#pragma mark - Lazy
- (QLCarCircleNaviView *)naviView {
    if(!_naviView) {
        _naviView = [QLCarCircleNaviView new];
        [_naviView.funBtn setImage:[UIImage imageNamed:@"CameraIcon_white"] forState:UIControlStateNormal];
        [_naviView.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_naviView.funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviView;
}
- (QLCarCircleHeadView *)headView {
    if(!_headView) {
        _headView = [[QLCarCircleHeadView alloc] init];
        _headView.nameLB.text = [QLUserInfoModel getLocalInfo].account.nickname;
        _headView.headBtn.tag = -1;
        _headView.storeNameBtn.tag = -1;
        [_headView.headBtn sd_setImageWithURL:[NSURL URLWithString:[QLUserInfoModel getLocalInfo].account.head_pic] forState:UIControlStateNormal];
        [_headView.storeNameBtn setTitle:[QLUserInfoModel getLocalInfo].business.business_name forState:UIControlStateNormal];
        [_headView.headBtn addTarget:self action:@selector(goStoreClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView.storeNameBtn addTarget:self action:@selector(goStoreClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _headView.bannerView.delegate = self;
        _headView.bannerView.imagesArr = @[[QLUserInfoModel getLocalInfo].account.back_pic];
        
    }
    return _headView;
}
- (QLCarCircleUnreadView *)unreadView {
    if (!_unreadView) {
        _unreadView = [QLCarCircleUnreadView new];
        [_unreadView.msgControl addTarget:self action:@selector(unreadMsgControlClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unreadView;
}
- (QLCarCircleAccMoreView *)accView {
    if (!_accView) {
        _accView = [QLCarCircleAccMoreView new];
        _accView.size = CGSizeMake(30, 30);
        [_accView.likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_accView.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accView;
}
- (QLDynamicSendMsgBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLDynamicSendMsgBottomView new];
        [_bottomView.sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
@end
