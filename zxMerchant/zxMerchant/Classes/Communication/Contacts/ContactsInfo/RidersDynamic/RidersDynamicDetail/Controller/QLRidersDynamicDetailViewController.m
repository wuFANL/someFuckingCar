//
//  QLRidersDynamicDetailViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLRidersDynamicDetailViewController.h"
#import "QLCarCircleTextCell.h"
#import "QLCarCircleImgCell.h"
#import "QLCarCircleAccCell.h"
#import "QLCarCircleLikeCell.h"
#import "QLCarCircleCommentCell.h"
#import "QLCarCircleAccMoreView.h"
#import "QLDynamicSendMsgBottomView.h"
#import "QLContactsInfoViewController.h"
#import "QLRidersDynamicListModel.h"

@interface QLRidersDynamicDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLCarCircleAccMoreView *accView;
@property (nonatomic, strong) QLDynamicSendMsgBottomView *bottomView;
@property (nonatomic, strong) QLRidersDynamicListModel *model;

@end

@implementation QLRidersDynamicDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //发送栏
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(45);
    }];
    [self bottomViewShowStatus:NO];
    //tableView
    [self tableViewSet];
    //数据
    [self detailRequest];
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - network
- (void)detailRequest {
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:DynamicPath params:@{@"operation_type":@"detail",@"account_id":QLNONull(self.account_id),@"dynamic_id":QLNONull(self.dynamic_id)} success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        self.model = [QLRidersDynamicListModel yy_modelWithJSON:response[@"result_info"][@"dynamic_detail"]];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
//点赞
- (void)likeRequest:(BOOL)isLike {
    QLRidersDynamicListModel *model = self.model;
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
    QLRidersDynamicListModel *model = self.model;
    [MBProgressHUD showCustomLoading:@""];
    [QLNetworkingManager postWithUrl:DynamicPath params:@{@"operation_type":@"interact/add",@"dynamic_id":model.dynamic_id,@"account_id":[QLUserInfoModel getLocalInfo].account.account_id,@"to_account_id":QLNONull(to_account_id),@"content":QLNONull(self.bottomView.tf.text)} success:^(id response) {
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
        [MBProgressHUD showSuccess:@"删除成功"];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:HUDDefaultShowTime];
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
    
    QLRidersDynamicListModel *model = self.model;
    self.bottomView.msgAccountId = model.account_id;
    
    self.bottomView.sendAccountId = [QLUserInfoModel getLocalInfo].account.account_id;
    self.bottomView.sendAccountName = [QLUserInfoModel getLocalInfo].account.nickname;
    self.bottomView.receiverAccountId = model.account_id;
    self.bottomView.receiverName = model.account_nickname;
    self.bottomView.tf.placeholder = @"评论";
    [self bottomViewShowStatus:YES];
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
    
    QLRidersDynamicListModel *model = self.model;
    NSString *myAccountId;
    for (QLRidersDynamicPraiseModel *praiseModel in model.praise_list) {
        if ([praiseModel.account_id isEqualToString:[QLUserInfoModel getLocalInfo].account.account_id]) {
            myAccountId = praiseModel.account_id;
        }
    }
    
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
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(45);
        }];
    } else {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}
//删除动态
- (void)deleteMsgClick:(UIButton *)sender {
    [[QLToolsManager share] alert:@"是否确认删除动态？" handler:^(NSError *error) {
        if (!error) {
            QLRidersDynamicListModel *model = self.model;
            [self deleteRequest:model];
        }
    }];
    
}
//去店铺
- (void)goStoreClick:(UIButton *)sender {
    QLContactsInfoViewController *ciVC = [[QLContactsInfoViewController alloc] initWithFirendID:self.model.account_id];
    ciVC.contactRelation = Friend;
    [self.navigationController pushViewController:ciVC animated:YES];
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
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleImgCell" bundle:nil] forCellReuseIdentifier:@"imgCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleAccCell" bundle:nil] forCellReuseIdentifier:@"accCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleLikeCell" bundle:nil] forCellReuseIdentifier:@"likeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLCarCircleCommentCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 2;
    if (self.model.file_array.count != 0) {
        row++;
    }
    if (self.model.praise_list.count != 0) {
        row++;
    }
    if (self.model.interact_list.count != 0) {
        row++;
    }
    return row;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QLCarCircleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.likeBtn.hidden = YES;
        cell.headBtn.tag = indexPath.section;
        [cell.headBtn addTarget:self action:@selector(goStoreClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.model = self.model;
        return cell;
    } else if (indexPath.row == 1&&self.model.file_array.count != 0) {
        QLCarCircleImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imgCell" forIndexPath:indexPath];
        cell.dataType = ImageType;
        cell.dataArr = [self.model.file_array mutableCopy];
        return cell;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-(self.model.interact_list.count != 0?2:1)&&self.model.praise_list.count != 0) {
        QLCarCircleLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"likeCell" forIndexPath:indexPath];
        cell.dataArr = self.model.praise_list;
        return cell;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1&&self.model.interact_list.count != 0) {
        QLCarCircleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
        cell.listArr = self.model.interact_list;
        cell.clickHandler = ^(id result, NSError *error) {
            QLRidersDynamicInteractModel *interactModel = result;
            

            self.bottomView.msgAccountId = self.model.account_id;
            
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
        cell.accLB.text = [NSString stringWithFormat:@"%@  %@",self.model.address,[QLToolsManager compareCurrentTime:self.model.create_time]];
        cell.deleteBtn.hidden = [self.model.account_id isEqualToString:[QLUserInfoModel getLocalInfo].account.account_id]?NO:YES;
        [cell.deleteBtn addTarget:self action:@selector(deleteMsgClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.moreOpenBtn addTarget:self action:@selector(moreOpenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}
#pragma mark - Lazy
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
@end
