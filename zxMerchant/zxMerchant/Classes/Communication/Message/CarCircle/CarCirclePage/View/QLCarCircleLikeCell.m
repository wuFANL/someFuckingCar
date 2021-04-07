//
//  QLCarCircleLikeCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/27.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarCircleLikeCell.h"
#import "QLCarCircleLikeNameItem.h"

@interface QLCarCircleLikeCell()<QLIrregularLayoutDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, assign) CGFloat collectionViewHeight;
@end
@implementation QLCarCircleLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //增加collectionView
    [self.bjView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}
#pragma mark - setter
//设置数据
- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
}
#pragma mark - action
//通过下标获取数据
- (NSString *)getResultByIndex:(NSInteger)index {
    NSString *title = @"";
    if (self.dataArr.count > 0) {
        id result = self.dataArr[self.dataArr.count-1-index];
        if ([result isKindOfClass:[NSString class]]) {
           title = result;
        }
    }
    return [NSString stringWithFormat:@"%@,",title];
}
#pragma mark - collectionView
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForSectionAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.width, 0.01);
}
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self getResultByIndex:indexPath.row];
    return CGSizeMake([title widthWithFontSize:13]+5, 15);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLCarCircleLikeNameItem *item = (QLCarCircleLikeNameItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"likeNameItem" forIndexPath:indexPath];
    item.titleLB.text = [self getResultByIndex:indexPath.row];
    return item;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
}
//属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]&&[object isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)object;
        CGFloat heigth  = collectionView.collectionViewLayout.collectionViewContentSize.height;
        if (self.collectionViewHeight == 0) {
            self.collectionViewHeight = heigth;
        }
        
        if (self.bjViewHeight.constant != self.collectionViewHeight+20) {
            self.bjViewHeight.constant = self.collectionViewHeight+20;
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [((UITableView *)self.superview) reloadData];
            }];
            [CATransaction commit];
        }
        
        
    }
}
- (void)dealloc {
    //移除监听
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}
#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if(!_collectionView) {
        QLCollectionViewFlowLayout *layout = [[QLCollectionViewFlowLayout alloc]initMinimumSpacing:QLMinimumSpacingMake(0, 0)];
        layout.dataSource = self;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = ClearColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"QLCarCircleLikeNameItem" bundle:nil] forCellWithReuseIdentifier:@"likeNameItem"];
        
        [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _collectionView;
}
@end
