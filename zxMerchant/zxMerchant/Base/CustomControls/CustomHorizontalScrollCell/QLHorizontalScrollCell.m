//
//  QLHorizontalScrollCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/1.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLHorizontalScrollCell.h"

@interface QLHorizontalScrollCell()<QLBaseCollectionViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;


@end

@implementation QLHorizontalScrollCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

#pragma mark - setter
- (void)setItemModel:(QLItemModel *)itemModel {
    _itemModel = itemModel;
    if (itemModel) {
        [self.collectionView removeFromSuperview];
        self.collectionView = nil;
        //collectionView
        self.collectionView = [[QLBaseCollectionView alloc] initWithFrame:self.bounds ItemModel:self.itemModel];
        self.collectionView.extendDelegate = self;
        self.collectionView.dataArr = [self.itemArr mutableCopy];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            if (self.collectionViewHeight != 0) {
                make.height.mas_equalTo(self.collectionViewHeight);
            }
        }];
    }
}
- (void)setCollectionViewHeight:(CGFloat)collectionViewHeight {
    if (self.collectionViewHeight != collectionViewHeight) {
        _collectionViewHeight = collectionViewHeight;
        if (self.collectionView) {
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
                make.height.mas_equalTo(self.collectionViewHeight);
            }];
            [(UITableView *)self.superview reloadData];
        }
    }
}
- (void)setItemArr:(NSArray *)itemArr {
    _itemArr = itemArr;
    self.collectionView.dataArr = [itemArr mutableCopy];
}
#pragma mark - collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:NSClassFromString(self.itemModel.itemName)]) {
        self.itemSetHandler(@{@"item":baseCell,@"dataArr":dataArr,@"indexPath":indexPath}, nil);
        
    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    self.itemSelectHandler(@{@"dataArr":dataArr,@"indexPath":indexPath}, nil);
}
@end
