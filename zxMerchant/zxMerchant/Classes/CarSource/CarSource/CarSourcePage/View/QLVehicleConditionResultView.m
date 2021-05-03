//
//  QLVehicleConditionResultView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/24.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLVehicleConditionResultView.h"
#import "QLConditionsItem.h"

@interface QLVehicleConditionResultView()<UICollectionViewDelegate,UICollectionViewDataSource,QLIrregularLayoutDataSource>
@property (nonatomic, strong) QLBaseButton *resetBtn;
@property (nonatomic, strong) QLBaseCollectionView *collectionView;

@end
@implementation QLVehicleConditionResultView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commentInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commentInit];
    }
    return self;
}
- (void)commentInit {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self addSubview:self.resetBtn];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.right.equalTo(self.resetBtn.mas_left).offset(-15);
        make.height.mas_equalTo(25);
    }];
}
#pragma mark - setter
- (void)setItemArr:(NSArray *)itemArr {
    _itemArr = itemArr;
    [self.collectionView reloadData];
}
#pragma mark - action
- (void)deleteBtnClick:(UIButton *)sender {
    NSInteger index = sender.tag;
    NSMutableArray *temArr = [NSMutableArray arrayWithArray:self.itemArr];
    [temArr removeObjectAtIndex:index];
    self.itemArr = temArr;
    self.dataHandler(self.itemArr);
}
- (void)resetBtnClick {
    self.itemArr = nil;
    self.dataHandler(self.itemArr);
}
#pragma mark - collectionView
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForSectionAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.width, 0);
}
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.itemArr[indexPath.row];
    return CGSizeMake([title widthWithFontSize:12]+10+20, 25);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLConditionsItem *item = (QLConditionsItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    item.showDeleteBtn = YES;
    item.deleteBtn.tag = indexPath.row;
    item.backgroundColor = WhiteColor;
    [item roundRectCornerRadius:3 borderWidth:1 borderColor:LightGrayColor];
    
    item.titleLB.text = self.itemArr[indexPath.row];
    [item.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return item;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - Lazy
- (QLBaseButton *)resetBtn {
    if (!_resetBtn) {
        _resetBtn = [QLBaseButton new];
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_resetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setImage:[UIImage imageNamed:@"refresh_gray"] forState:UIControlStateNormal];
        [_resetBtn layoutButtonWithEdgeInsetsStyle:QLButtonEdgeInsetsStyleLeft imageTitleSpace:8];
        [_resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLCollectionViewFlowLayout *layout = [[QLCollectionViewFlowLayout alloc]initMinimumSpacing:QLMinimumSpacingMake(10, 10)];
        layout.dataSource = self;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = ClearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"QLConditionsItem" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
@end
