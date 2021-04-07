//
//  QLVipPriceListView.m
//  zxMerchant
//
//  Created by lei qiao on 2021/1/10.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLVipPriceListView.h"
#import "QLVipPriceItem.h"

@interface QLVipPriceListView()<QLBaseCollectionViewDelegate>
@property (nonatomic, assign) NSInteger selectIndex;

@end
@implementation QLVipPriceListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLVipPriceListView viewFromXib];
        
        [self commentInit];
    }
    return self;
}

- (void)commentInit {
    [self.tfView roundRectCornerRadius:10 borderWidth:1 borderColor:GreenColor];
    NSString *reductStr = @"立减5元";
    NSString *placeholderStr = [NSString stringWithFormat:@"填写邀请码%@(非必填)",reductStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#B8BFCA"]}];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#F1AD62"]} range:[placeholderStr rangeOfString:reductStr]];
    self.tf.attributedPlaceholder = attStr;
    self.tf.borderStyle = UITextBorderStyleNone;
    
    [self.bjView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bjView);
        make.bottom.equalTo(self.tfView.mas_top).offset(-15);
        make.height.mas_equalTo(98);
    }];
    
}
#pragma mark - collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLVipPriceItem class]]) {
        QLVipPriceItem *item = (QLVipPriceItem *)baseCell;
        [item roundRectCornerRadius:10 borderWidth:1 borderColor:[UIColor colorWithHexString:self.selectIndex == indexPath.row ?@"#F9E2AC":@"#CBCBCB"]];
//        item.timeLB.textColor = 
        
        
    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    self.selectIndex = indexPath.row;
    [collectionView reloadData];
    
}
#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLItemModel *model = [QLItemModel new];
        model.rowCount = 1;
        model.columnCount = 3;
        model.Spacing = QLMinimumSpacingMake(10, 10);
        model.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        model.itemSize = CGSizeMake(98, 98);
        model.itemName = @"QLVipPriceItem";
        
        _collectionView = [[QLBaseCollectionView alloc] initWithSize:CGSizeMake(self.bjView.width, 98) ItemModel:model];
        _collectionView.extendDelegate = self;
    }
    return _collectionView;
}
@end
