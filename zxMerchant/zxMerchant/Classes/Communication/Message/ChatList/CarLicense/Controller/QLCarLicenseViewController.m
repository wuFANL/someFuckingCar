//
//  QLCarLicenseViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/15.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarLicenseViewController.h"
#import "QLImageItem.h"
#import "QLPicturesDetailViewController.h"

@interface QLCarLicenseViewController ()<QLBaseCollectionViewDelegate>
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *chooseArr;
@end

@implementation QLCarLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.navigationItem.title = @"选择图片";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    //collectionView
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.collectionView.dataArr = [@[@"1",@"2",@"3"] mutableCopy];
}
#pragma mark - action
- (void)sendBtnClick {
    
}
- (void)chooseBtnClick:(UIButton *)sender {
    NSInteger index = sender.tag;
    id obj = self.collectionView.dataArr[index];
    if ([self.chooseArr containsObject:obj]) {
        [self.chooseArr removeObject:obj];
    } else {
        [self.chooseArr addObject:obj];
    }
    [self.collectionView reloadData];
}
#pragma mark - collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLImageItem class]]) {
        QLImageItem *item = (QLImageItem *)baseCell;
        item.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        item.deleteBtn.hidden = NO;
        item.deleteBtn.tag = indexPath.row;
        [item.deleteBtn setImage:[UIImage imageNamed:@"noSelect_gray"] forState:UIControlStateNormal];
        [item.deleteBtn setImage:[UIImage imageNamed:@"selectSuccess_green"] forState:UIControlStateSelected];
        [item.deleteBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        id obj = dataArr[indexPath.row];
        item.deleteBtn.selected = [self.chooseArr containsObject:obj]?YES:NO;
    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {

    QLPicturesDetailViewController *pdVC = [QLPicturesDetailViewController new];
    pdVC.imgsArr = dataArr;
    pdVC.intoIndex = indexPath.row;
    [self.navigationController pushViewController:pdVC animated:YES];
}
#pragma mark - Lazy
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"greenBj_332"] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitle:@"发送(0/9)" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLItemModel *model = [QLItemModel new];
        model.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        model.Spacing = QLMinimumSpacingMake(8, 8);
        model.columnCount = 4;
        CGFloat width = (self.view.width-(15*2)-(model.columnCount-1)*8)/model.columnCount;
        model.itemSize = CGSizeMake(width, width);
        model.itemName = @"QLImageItem";
        _collectionView = [[QLBaseCollectionView alloc] initWithFrame:self.view.frame ItemModel:model];
        _collectionView.extendDelegate = self;
    }
    return _collectionView;
}
- (NSMutableArray *)chooseArr {
    if (!_chooseArr) {
        _chooseArr = [NSMutableArray array];
    }
    return _chooseArr;
}
@end
