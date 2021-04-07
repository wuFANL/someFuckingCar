//
//  QLVehicleSortView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/22.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLVehicleSortView.h"
#import "QLCollectionValueCell.h"

@interface QLVehicleSortView()<QLBaseCollectionViewDelegate>


@end
@implementation QLVehicleSortView
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
    self.currentIndex = -1;
    self.showStatusItem = NO;
}
#pragma mark - setter
- (void)setShowWarn:(BOOL)showWarn {
    _showWarn = showWarn;
    [self.collectionView reloadData];
}
- (void)setShowStatusItem:(BOOL)showStatusItem {
    _showStatusItem = showStatusItem;
    //collectionView
    [self addCollectionView];
}
- (void)setShowScreenItem:(BOOL)showScreenItem {
    _showScreenItem = showScreenItem;
    //collectionView
    [self addCollectionView];
}
- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    self.collectionView.dataArr = dataArr;
}
- (void)setShowOriginalItem:(BOOL)showOriginalItem {
    _showOriginalItem = showOriginalItem;
    if (showOriginalItem) {
        self.currentIndex = -1;
        
        self.dataArr = [NSMutableArray arrayWithArray:@[@"智能排序",@"品牌",@"价格"]];
        if (self.showStatusItem) {
            [self.dataArr addObject:@"在售"];
        }
        if (self.showScreenItem) {
            [self.dataArr addObject:@"筛选"];
        }
        [self.collectionView reloadData];
    }
}
#pragma mark - collectionView
- (void)addCollectionView {
    [self.collectionView removeFromSuperview];
    //collectionView初始化
    QLItemModel *model = [QLItemModel new];
    self.dataArr = [NSMutableArray arrayWithArray:@[@"智能排序",@"品牌",@"价格"]];
    if (self.showStatusItem) {
        [self.dataArr addObject:@"在售"];
    }
    if (self.showScreenItem) {
        [self.dataArr addObject:@"筛选"];
    }
    model.columnCount = self.dataArr.count;
    model.rowCount = 1;
    model.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    model.Spacing = QLMinimumSpacingMake(5, 5);
    model.registerType = CellNibRegisterType;
    model.itemName = @"QLCollectionValueCell";
    QLBaseCollectionView *collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 44) ItemModel:model];
    collectionView.scrollEnabled = NO;
    collectionView.extendDelegate = self;
    collectionView.dataArr = self.dataArr;
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    self.collectionView = collectionView;
}
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLCollectionValueCell class]]) {
        QLCollectionValueCell *item = (QLCollectionValueCell *)baseCell;
        NSString *title = [NSString stringWithFormat:@"%@",QLNONull(dataArr[indexPath.row])];
        //警告图片
        UIImageView *imgView = [item viewWithTag:100];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        if (indexPath.item == 3) {
            if (!imgView) {
                imgView = [UIImageView new];
                imgView.image = [UIImage imageNamed:@"statusWarn"];
                imgView.tag = 100;
                [item addSubview:imgView];
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(item);
                    make.left.equalTo(item).offset(2);
                }];
            }
            //是否隐藏
            imgView.hidden = !self.showWarn;
        } else {
            [imgView removeFromSuperview];
        }
        [item.titleBtn setTitle:title forState:UIControlStateNormal];
        [item.titleBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [item.titleBtn setTitleColor:GreenColor forState:UIControlStateSelected];
        if (![title isEqualToString:@"品牌"]||![title isEqualToString:@"筛选"]) {
            item.titleBtn.selected = self.currentIndex==indexPath.row?YES:NO;
        }

    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    self.currentIndex = indexPath.row;
    [collectionView reloadData];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectTypeBack:)]) {
        [self.delegate selectTypeBack:indexPath.row];
    }

}
@end
