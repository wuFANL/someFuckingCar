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
#import "QLChooseBrandViewController.h"
#import "QLCardSelectModel.h"

@interface QLAdvancedScreeningViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) QLBaseButton *resetBtn;
@property (nonatomic, strong) QLSubmitBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *sectionArr;
@property (nonatomic, strong) NSMutableDictionary *cellHeightDic;
@property (nonatomic, strong) QLAddSubscriptionView *asView;
@property (nonatomic, strong) NSMutableDictionary *conditionDic;
@property (nonatomic, strong) QLCardSelectModel *cardSelectModel;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
}
#pragma mark - network
- (void)addSubscribeRequest {
    [MBProgressHUD showCustomLoading:@""];
    
    //价格
    NSString *priceAreaStr = self.conditionDic[@"priceArea"];
    NSString *min_price = @"0";
    NSString *max_price = @"9999999";
    if ([priceAreaStr containsString:@"-"]) {
        NSArray *priceAreaArr = [priceAreaStr componentsSeparatedByString:@"-"];
        min_price = [(NSString *)priceAreaArr.firstObject stringByReplacingOccurrencesOfString:@"万" withString:@"0000"];
        max_price = [(NSString *)priceAreaArr.lastObject stringByReplacingOccurrencesOfString:@"万" withString:@"0000"];
    } else {
        if (![priceAreaStr isEqualToString:@"不限"]&&priceAreaStr.length != 0) {
            if ([priceAreaStr containsString:@"万"]) {
                NSArray *priceAreaArr = [priceAreaStr componentsSeparatedByString:@"万"];
                if ([priceAreaArr.lastObject isEqualToString:@"以内"]) {
                    max_price = StringWithFormat(@"%@0000", priceAreaArr.firstObject);
                } else {
                    min_price = StringWithFormat(@"%@0000", priceAreaArr.firstObject);
                }
                
            }
            
        }
    }
    
    //车龄
    NSString *vehicle_ageStr = self.conditionDic[@"vehicle_age"];
    NSString *min_vehicle_age = @"0";
    NSString *max_vehicle_age = @"9999999";
    if ([vehicle_ageStr containsString:@"-"]) {
        NSArray *vehicle_ageArr = [vehicle_ageStr componentsSeparatedByString:@"-"];
        min_vehicle_age = [(NSString *)vehicle_ageArr.firstObject stringByReplacingOccurrencesOfString:@"年" withString:@""];
        max_vehicle_age = [(NSString *)vehicle_ageArr.lastObject stringByReplacingOccurrencesOfString:@"年" withString:@""];
    } else {
        if (![vehicle_ageStr isEqualToString:@"不限"]&&vehicle_ageStr.length != 0) {
            min_vehicle_age = [vehicle_ageStr stringByReplacingOccurrencesOfString:@"年以上" withString:@""];
        }
    }
    
    //里程
    NSString *driving_distanceStr = self.conditionDic[@"driving_distance"];
    NSString *min_driving_distance = @"0";
    NSString *max_driving_distance = @"9999999";
    if ([driving_distanceStr containsString:@"-"]) {
        NSArray *driving_distanceArr = [driving_distanceStr componentsSeparatedByString:@"-"];
        min_driving_distance = [(NSString *)driving_distanceArr.firstObject stringByReplacingOccurrencesOfString:@"万公里" withString:@"0000"];
        max_driving_distance = [(NSString *)driving_distanceArr.lastObject stringByReplacingOccurrencesOfString:@"万公里" withString:@"0000"];
    } else {
        if (![driving_distanceStr isEqualToString:@"不限"]&&driving_distanceStr.length != 0) {
            min_driving_distance = [driving_distanceStr stringByReplacingOccurrencesOfString:@"万公里以上" withString:@"0000"];
        }
    }
    
    //排量
    NSString *displacementStr = self.conditionDic[@"displacement"];
    NSString *min_displacement = @"0";
    NSString *max_displacement = @"9999999";
    if ([displacementStr containsString:@"-"]) {
        NSArray *displacementArr = [displacementStr componentsSeparatedByString:@"-"];
        min_displacement = displacementArr.firstObject;
        max_displacement = displacementArr.lastObject;
    } else {
        if (![displacementStr isEqualToString:@"不限"]&&displacementStr.length != 0) {
            min_displacement = [displacementStr stringByReplacingOccurrencesOfString:@"以上" withString:@""];
        }
    }
    
    //品牌
    NSArray *carBrandArr = self.conditionDic[@"carName"];
    NSMutableArray *temBrandArr = [NSMutableArray array];
    for (QLBrandInfoModel *model in carBrandArr) {
        [temBrandArr addObject:[NSString stringWithFormat:@"{\"brand_id\":\"%@\",\"brand_name\":\"%@\"}",model.brand_id,model.brand_name]];
    }
    NSString *brandStr = StringWithFormat(@"[%@]", [temBrandArr componentsJoinedByString:@","]);
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:@{
        @"operation_type":@"add_subscribe",
        @"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id),
        @"title":self.asView.textTF.text,
        @"min_price":min_price,
        @"max_price":max_price,
        @"factory_way":QLNONull([self.conditionDic[@"factory_way"] isEqualToString:@"不限"]?@"":self.conditionDic[@"factory_way"]),
        @"car_type":QLNONull([self.conditionDic[@"car_type"] isEqualToString:@"0"]?@"":self.conditionDic[@"car_type"]),
        @"brand_data":QLNONull(brandStr),
        @"min_vehicle_age":min_vehicle_age,
        @"max_vehicle_age":max_vehicle_age,
        @"emission_standard":QLNONull([self.conditionDic[@"emission_standard"] isEqualToString:@"不限"]?@"":self.conditionDic[@"emission_standard"]),
        @"transmission_case":QLNONull([self.conditionDic[@"transmission_case"] isEqualToString:@"不限"]?@"":self.conditionDic[@"transmission_case"]),
        @"min_driving_distance":min_driving_distance,
        @"max_driving_distance":max_driving_distance,
        @"min_displacement":min_displacement,
        @"max_displacement":max_displacement,
        @"displacement_type":QLNONull(self.conditionDic[@"displacement_type"]),
        
    }];
    
    [paramDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        if (value.length == 0) {
            [paramDic removeObjectForKey:key];
        }
    }];
    
    [QLNetworkingManager postWithUrl:BusinessPath params:paramDic success:^(id response) {
        //返回结果
        if (self.resultHandler) {
            self.resultHandler(self.conditionDic, nil);
        }
        //页面返回
        [MBProgressHUD showSuccess:@"订阅成功"];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:HUDDefaultShowTime];
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - action
//订阅
- (void)subscriptionBtnClick {
    [self.asView hidden];
    if (self.asView.textTF.text.length == 0) {
        return;
    }
    
    [self addSubscribeRequest];
}
//确定
- (void)funBtnClick {
    WEAKSELF
    if (self.conditionDic.count == 1&&[self.conditionDic[@"displacement_type"] isEqualToString:@"L"]) {
        [MBProgressHUD showError:@"请选择筛选条件"];
        return;
    }
    if (self.isSubscription) {
        //订阅
        [[QLToolsManager share] alert:@"是否添加订阅" handler:^(NSError *error) {
            if (!error) {
                [self.asView show];
            }else{
                if (weakSelf.resultHandler) {
                    weakSelf.resultHandler(weakSelf.conditionDic, nil);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    } else {
        //选择条件
//        if (self.resultHandler) {
//            self.resultHandler(self.conditionDic, nil);
//        }
//        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
//选择品牌
- (void)addBrandBtnClick {
    WEAKSELF
    QLChooseBrandViewController *cbVC = [QLChooseBrandViewController new];
    cbVC.onlyShowBrand = YES;
    cbVC.callback = ^(QLBrandInfoModel * _Nullable brandModel, QLSeriesModel * _Nullable seriesModel, QLTypeInfoModel * _Nullable typeModel) {
        if (brandModel.brand_id.length != 0) {
            
            NSMutableArray *temArr = [NSMutableArray arrayWithArray:weakSelf.conditionDic[@"carName"]];
            [temArr addObject:brandModel];
            [weakSelf.conditionDic setObject:temArr forKey:@"carName"];
            [self.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:cbVC animated:YES];
}
//排量类型选择
- (void)displacementTypeBtnClick:(UIButton *)sender {
//    NSInteger index = sender.tag;
    NSInteger section = [self.tableView numberOfSections]-1;
    QLAdvancedScreeningSectionView *sectionView = [self.view viewWithTag:100+section];
    if (sectionView.aBtn == sender) {
        sectionView.aBtn.selected = YES;
        sectionView.bBtn.selected = NO;
    } else {
        sectionView.aBtn.selected = NO;
        sectionView.bBtn.selected = YES;
    }
//    [self.conditionDic setObject:index==0?@"L":@"T" forKey:@"displacement_type"];
}
//重置
- (void)resetBtnClick {
    self.conditionDic = nil;
    [self.tableView reloadData];
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
    
    
    
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:weakSelf.sectionArr.count-1] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
    });
    
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
        [cell.addBtn addTarget:self action:@selector(addBrandBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableArray *temArr = [NSMutableArray array];
        for (QLBrandInfoModel *model in self.conditionDic[@"carName"]) {
            [temArr addObject:model.brand_name];
        }
        cell.itemArr = temArr;
        cell.deleteHandler = ^(id result, NSError *error) {
            NSInteger index = [result integerValue];
            NSMutableArray *carArr = self.conditionDic[@"carName"];
            [carArr removeObjectAtIndex:index];
            
            [self.conditionDic setObject:carArr forKey:@"carName"];
            [self.tableView reloadData];
        };
        
        return cell;
    } else {
        QLAdvancedScreeningChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell" forIndexPath:indexPath];
        cell.isChooseModel = NO;
        cell.tag = indexPath.section;
        NSArray * __block dataArr = nil;
        NSString * __block key = @"";
        if (indexPath.section == 0) {
            key = @"priceArea";
            dataArr = self.cardSelectModel.priceArea;
        } else if (indexPath.section == 1) {
            key = @"factory_way";
            dataArr = @[@"不限",@"国产",@"德系",@"美系",@"日系",@"韩系",@"法系",@"其他"];
        } else if (indexPath.section == 2) {
            key = @"car_type";
            cell.isChooseModel = YES;
            dataArr = self.cardSelectModel.car_type;
        } else if (indexPath.section == [tableView numberOfSections]-5) {
            key = @"vehicle_age";
            dataArr = self.cardSelectModel.vehicle_age;
        } else if (indexPath.section == [tableView numberOfSections]-4) {
            key = @"emission_standard";
            dataArr = @[@"不限",@"国三及以上",@"国四及以上",@"国五及以上",@"国六"];
        } else if (indexPath.section == [tableView numberOfSections]-3) {
            key = @"transmission_case";
            dataArr = @[@"不限",@"自动",@"手动"];
        } else if (indexPath.section == [tableView numberOfSections]-2) {
            key = @"driving_distance";
            dataArr = self.cardSelectModel.driving_distance;
        } else if (indexPath.section == [tableView numberOfSections]-1) {
            key = @"displacement";
            dataArr = @[@"不限",@"0-1.0",@"1.0-1.4",@"1.4-1.8",@"1.8-2.5",@"2.5以上"];
        }
        cell.collectionViewHeight = [self.cellHeightDic[indexPath] floatValue];
        cell.dataArr = dataArr;
        
        NSString *temContent = self.conditionDic[key];
        NSInteger selectIndex = 0;
        if ([key isEqualToString:@"car_type"]) {
            selectIndex = [temContent integerValue];
        } else {
            for (NSString *temStr in dataArr) {
                if ([temContent isEqualToString:temStr]) {
                    selectIndex = [dataArr indexOfObject:temStr];
                }
            }
        }
        
        cell.currentSelectIndex = selectIndex;
        
        cell.clickHandler = ^(id result) {
            NSDictionary *dic = result;
            NSInteger index = [dic[@"selectIndex"] integerValue];
            NSString *obj = dataArr[index];
            if (dataArr.count > index && obj) {
                [self.conditionDic setObject:obj forKey:key];
            }
        };
        
        cell.refresHandler = ^(id result) {
            CGFloat height = [result floatValue];
            self.cellHeightDic[indexPath] = @(height);
            [tableView reloadData];
        };
        
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    QLAdvancedScreeningSectionView *sectionView = [QLAdvancedScreeningSectionView new];
    sectionView.tag = 100+section;
    sectionView.showFunBtn = (section == [tableView numberOfSections]-1)?YES:NO;
    sectionView.titleLB.text = self.sectionArr[section];
    [sectionView.aBtn addTarget:self action:@selector(displacementTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView.bBtn addTarget:self action:@selector(displacementTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *displacement_type = self.conditionDic[@"displacement_type"];
    
    if ([displacement_type isEqualToString:@"L"]) {
        sectionView.aBtn.selected = YES;
        sectionView.bBtn.selected = NO;
    } else {
        sectionView.aBtn.selected = NO;
        sectionView.bBtn.selected = YES;
    }
    
    
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 100;
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
        [_asView.submitBtn addTarget:self action:@selector(subscriptionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _asView;
}
- (NSMutableDictionary *)conditionDic {
    if (!_conditionDic) {
        _conditionDic = [NSMutableDictionary dictionary];
//        _conditionDic[@"displacement_type"] = @"L";
    }
    return _conditionDic;
}
- (QLCardSelectModel *)cardSelectModel {
    if (!_cardSelectModel) {
        _cardSelectModel = [[QLCardSelectModel alloc]init];
    }
    return _cardSelectModel;
}
@end
