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

@interface QLChatListPageViewController ()<QLBaseCollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, assign) NSInteger chooseTypeIndex;
@property (nonatomic, strong) QLChatBottomView *bottomView;

@end

@implementation QLChatListPageViewController
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
    self.collectionView.dataArr = [@[@"1",@"2",@"3"] mutableCopy];
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
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLChatMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatMsgCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.msgType = TextMsg;
        cell.msgReceiver = MyMsg;
    } else if (indexPath.section == 1) {
        cell.msgType = ImgMsg;
        cell.msgReceiver = OtherMsg;
    } else {
        cell.msgType = AskMsg;
        cell.msgReceiver = OtherMsg;
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    UILabel *lb = [UILabel new];
    lb.textColor = [UIColor colorWithHexString:@"#999999"];
    lb.font = [UIFont systemFontOfSize:13];
    lb.text = @"时间";
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
        QLChatListHeadItem *item = (QLChatListHeadItem *)baseCell;
        [item.imgView roundRectCornerRadius:2 borderWidth:3 borderColor:indexPath.row == self.chooseTypeIndex?GreenColor:ClearColor];
        
    }
}
-(void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    self.chooseTypeIndex = indexPath.row;
    [collectionView reloadData];
}
#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLItemModel *model = [QLItemModel new];
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
