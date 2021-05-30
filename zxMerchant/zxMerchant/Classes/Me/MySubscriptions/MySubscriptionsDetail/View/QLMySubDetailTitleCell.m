//
//  QLMySubDetailTitleCell.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/28.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLMySubDetailTitleCell.h"
#import "QLIconItem.h"

@interface QLMySubDetailTitleCell()<QLIrregularLayoutDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, assign) CGFloat collectionViewHeight;

@end
@implementation QLMySubDetailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bjView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bjView);
    }];
}

- (void)updateTimeWithString:(NSString *)timeStr {
    self.timeLB.text = timeStr;
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
//动态高度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]&&[object isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)object;
        CGFloat heigth  = collectionView.collectionViewLayout.collectionViewContentSize.height;
        if (self.collectionViewHeight == 0) {
            self.collectionViewHeight = heigth;
            self.bjViewHeight.constant = heigth;
            [((UITableView *)self.superview) reloadData];
        }
        
    }
}
#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLCollectionViewFlowLayout *layout = [[QLCollectionViewFlowLayout alloc]initMinimumSpacing:QLMinimumSpacingMake(6, 6)];
        layout.dataSource = self;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"QLIconItem" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _collectionView;
}

@end
