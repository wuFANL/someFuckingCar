//
//  QLAdvancedScreeningViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/28.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLAdvancedScreeningViewController.h"
#import "QLAdvancedScreeningSectionView.h"
#import "QLAdvancedScreeningChooseCell.h"
#import "QLAdvancedScreeningAddCell.h"
#import "QLSubmitBottomView.h"
#import "QLAddSubscriptionView.h"

@interface QLAdvancedScreeningViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseButton *resetBtn;
@property (nonatomic, strong) QLSubmitBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *sectionArr;
@property (nonatomic, strong) NSMutableDictionary *cellHeightDic;
@property (nonatomic, strong) QLAddSubscriptionView *asView;
@end

@implementation QLAdvancedScreeningViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.resetBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomOffset?-34:0);
        make.height.mas_equalTo(50);
    }];
    //tableView
    [self tableViewSet];
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - action
//确定
- (void)funBtnClick {
    if (self.isSubscription) {
        //是筛选
        [self.asView show];
    }
}
//重置
- (void)resetBtnClick {
    
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
        self.asView.bjViewBottom.constant = keyboardFrame.size.height;
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
        self.asView.bjViewBottom.constant = 0;
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
    [self.tableView registerClass:[QLAdvancedScreeningChooseCell class] forCellReuseIdentifier:@"chooseCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QLAdvancedScreeningAddCell" bundle:nil] forCellReuseIdentifier:@"addCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3||(indexPath.section == 4&&self.showCity)) {
        QLAdvancedScreeningAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell" forIndexPath:indexPath];
        cell.itemArr = @[@"阿斯顿马丁",@"阿斯顿马丁",@"阿斯顿马丁",@"阿斯顿马丁",@"阿斯顿马丁"];
        return cell;
    } else {
        QLAdvancedScreeningChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell" forIndexPath:indexPath];
        cell.isChooseModel = NO;
        NSArray *dataArr = nil;
        if (indexPath.section == 0) {
            dataArr = @[@"不限",@"5万以内",@"5万-10万",@"10万-15万",@"15万-20万",@"20万-30万",@"30万-50万",@"50万以上"];
        } else if (indexPath.section == 1) {
            dataArr = @[@"国产",@"德系",@"美系",@"日系",@"韩系",@"法系",@"其他"];
        } else if (indexPath.section == 2) {
            cell.isChooseModel = YES;
            dataArr = @[@"两厢轿车",@"三厢轿车",@"跑车",@"SUV",@"MPV",@"面包车",@"皮卡"];
        } else if (indexPath.section == [tableView numberOfSections]-5) {
            dataArr = @[@"0-6年",@"6-10年",@"10-15年",@"15年以上"];
        } else if (indexPath.section == [tableView numberOfSections]-4) {
            dataArr = @[@"不限",@"国三及以上",@"国四及以上",@"国五及以上",@"国六"];
        } else if (indexPath.section == [tableView numberOfSections]-3) {
            dataArr = @[@"不限",@"自动",@"手动"];
        } else if (indexPath.section == [tableView numberOfSections]-2) {
            dataArr = @[@"不限",@"0-5万公里",@"5-10万公里",@"10-15万公里",@"15-20万公里",@"20万公里以上"];
        } else if (indexPath.section == [tableView numberOfSections]-1) {
            dataArr = @[@"不限",@"0-1.0",@"1.0-1.4",@"1.4-1.8",@"1.8-2.5",@"2.5以上"];
        }
        cell.collectionViewHeight = [self.cellHeightDic[indexPath] floatValue];
        cell.dataArr = dataArr;
        cell.refreshandler = ^(id result) {
            CGFloat height = [result floatValue];
            self.cellHeightDic[indexPath] = @(height);
            [tableView reloadData];
        };
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QLAdvancedScreeningSectionView *sectionView = [QLAdvancedScreeningSectionView new];
    sectionView.showFunBtn = (section == [tableView numberOfSections]-1)?YES:NO;
    sectionView.titleLB.text = self.sectionArr[section];
    
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}
#pragma mark - Lazy
- (QLBaseButton *)resetBtn {
    if (!_resetBtn) {
        _resetBtn = [[QLBaseButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_resetBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}
- (QLSubmitBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [QLSubmitBottomView new];
        [_bottomView.funBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_bottomView.funBtn addTarget:self action:@selector(funBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (NSMutableArray *)sectionArr {
    if (!_sectionArr) {
        _sectionArr = [@[@"价格区间",@"国别",@"车型",@"品牌车系",@"车龄",@"排放标准",@"变速箱",@"行驶里程",@"排放量"] mutableCopy];
        if (self.showCity) {
            [_sectionArr insertObject:@"车源城市" atIndex:3];
        }
    }
    return _sectionArr;
}
- (NSMutableDictionary *)cellHeightDic {
    if (!_cellHeightDic) {
        _cellHeightDic = [NSMutableDictionary dictionary];
    }
    return _cellHeightDic;
}
- (QLAddSubscriptionView *)asView {
    if(!_asView) {
        _asView = [QLAddSubscriptionView new];
    }
    return _asView;
}
@end