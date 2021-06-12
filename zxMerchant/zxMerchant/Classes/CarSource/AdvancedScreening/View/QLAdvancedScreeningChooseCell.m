//
//  QLAdvancedScreeningChooseCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLAdvancedScreeningChooseCell.h"
#import "QLIconItem.h"
#import "QLCarStyleItem.h"

@interface QLAdvancedScreeningChooseCell()<QLBaseCollectionViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, assign) NSInteger selectIndex;


@end
@implementation QLAdvancedScreeningChooseCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

#pragma mark - setter
- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
    
    self.collectionView.dataArr = [dataArr mutableCopy];
    [self addSubview:self.collectionView];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_offset(self.collectionViewHeight);
    }];
    
}
- (void)setCurrentSelectIndex:(NSInteger)currentSelectIndex {
    _currentSelectIndex = currentSelectIndex;
    self.selectIndex = currentSelectIndex;
    [self.collectionView reloadData];
    
}
#pragma mark - collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLCarStyleItem class]]) {
        //车型选择
        QLCarStyleItem *item = (QLCarStyleItem *)baseCell;
        [item.carBtn setTitle:dataArr[indexPath.row] forState:UIControlStateNormal];
        [item.carBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"carStyle_%ld",indexPath.row]] forState:UIControlStateNormal];
        item.carBtn.selected = self.selectIndex==indexPath.row?YES:NO;
    } else if ([baseCell isKindOfClass:[QLIconItem class]]) {
        QLIconItem *item = (QLIconItem *)baseCell;
        item.backgroundColor = WhiteColor;
        [item.iconBtn setTitle:dataArr[indexPath.row] forState:UIControlStateNormal];
        [item.iconBtn setTitleColor:BlackColor forState:UIControlStateNormal];
        [item.iconBtn setTitleColor:GreenColor forState:UIControlStateSelected];
        [item.iconBtn setBackgroundImage:[UIImage imageNamed:@"itemBj_gray"] forState:UIControlStateNormal];
        [item.iconBtn setBackgroundImage:[UIImage imageNamed:@"itemBjSelected"] forState:UIControlStateSelected];
        item.iconBtn.selected = self.selectIndex==indexPath.row?YES:NO;
    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    self.selectIndex = indexPath.row;
    [self.collectionView reloadData];
    
    self.clickHandler(@{@"cell":self,@"selectIndex":@(self.selectIndex)});
}
//动态高度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]&&[object isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)object;
        CGFloat heigth  = collectionView.collectionViewLayout.collectionViewContentSize.height;
        if (self.collectionViewHeight == 0) {
            self.collectionViewHeight = heigth;
            self.refresHandler(@(self.collectionViewHeight));
        }
        
    }
}
- (void)dealloc {
    //移除监听
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}
#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLItemModel *model = [QLItemModel new];
        model.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        model.Spacing = QLMinimumSpacingMake(12, 12);
        model.columnCount = 3;
        model.registerType = CellNibRegisterType;
        model.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat width = (ScreenWidth - 15*(model.columnCount+1))/model.columnCount;
        if (!self.isChooseModel) {
            model.itemSize = CGSizeMake(width, 44);
            model.itemName = @"QLIconItem";
        } else {
            model.itemSize = CGSizeMake(width, 80);
            model.itemName = @"QLCarStyleItem";
        }
        
        _collectionView = [[QLBaseCollectionView alloc]initWithFrame:self.bounds ItemModel:model];
        _collectionView.scrollEnabled = NO;
        _collectionView.extendDelegate = self;
        [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _collectionView;
}
@end
