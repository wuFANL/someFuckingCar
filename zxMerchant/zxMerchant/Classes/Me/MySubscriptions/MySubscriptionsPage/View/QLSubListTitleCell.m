//
//  QLSubListTitleCell.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/28.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLSubListTitleCell.h"
#import "QLIconItem.h"

@interface QLSubListTitleCell()<QLIrregularLayoutDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;

@end
@implementation QLSubListTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bjView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bjView);
    }];
    
}
#pragma mark -setter
- (void)setIconArr:(NSMutableArray *)iconArr {
    _iconArr = iconArr;
    [self.collectionView reloadData];
}
#pragma mark -collectionView
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForSectionAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeZero;
}
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.iconArr[indexPath.row];
    return CGSizeMake([title widthWithFontSize:10]+8, 20);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iconArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLIconItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *title = self.iconArr[indexPath.row];
    [item.iconBtn setTitle:title forState:UIControlStateNormal];
    [item.iconBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [item.iconBtn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [item.iconBtn roundRectCornerRadius:2 borderWidth:1 borderColor:ClearColor];
    return item;
}
#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLCollectionViewFlowLayout *layout = [[QLCollectionViewFlowLayout alloc]initMinimumSpacing:QLMinimumSpacingMake(6, 6)];
        layout.dataSource = self;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"QLIconItem" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

@end
