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

@interface QLEditTopCarViewController ()<UITableViewDelegate,UITableViewDataSource,QLBaseCollectionViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, strong) QLEditTopPriceView *priceView;

@end

@implementation QLEditTopCarViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"头条车源";
    //collectionView
    self.collectionView.dataArr = [@[@"1",@"2",@"3",@"4"] mutableCopy];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(140);
    }];
    //tableView
    [self tableViewSet];
}
#pragma mark - action
//降价确认
- (void)confirmBtnClick:(UIButton *)sender {
    
}
//添加头条车辆
- (void)addBtnClick:(UIButton *)sender {
    [self.priceView show];
}
#pragma mark - tableView
- (void)tableViewSet {
    self.initStyle = UITableViewStyleGrouped;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QLEditTopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editTopCarCell" forIndexPath:indexPath];
    cell.addBtn.tag = indexPath.row;
    [cell.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
