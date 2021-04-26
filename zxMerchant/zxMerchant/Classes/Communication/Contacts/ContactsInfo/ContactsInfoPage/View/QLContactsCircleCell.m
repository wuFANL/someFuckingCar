//
//  QLContactsCircleCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/10.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLContactsCircleCell.h"
#import "QLImageItem.h"

@interface QLContactsCircleCell()<QLBaseCollectionViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;

@end
@implementation QLContactsCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bjView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bjView);
    }];
    
}
#pragma mark - collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLImageItem class]]) {
        QLImageItem *item = (QLImageItem *)baseCell;
        item.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
        [item.imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"file_url"]]];
    }
}
#pragma mark - Lazy
- (QLBaseCollectionView *)collectionView {
    if(!_collectionView) {
        QLItemModel *model = [QLItemModel new];
        model.rowCount = 1;
        model.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        model.Spacing = QLMinimumSpacingMake(10, 10);
        model.itemSize = CGSizeMake(45, 45);
        model.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        model.itemName = @"QLImageItem";
        model.registerType = CellNibRegisterType;
        _collectionView = [[QLBaseCollectionView alloc] initWithFrame:self.bjView.bounds ItemModel:model];
        _collectionView.extendDelegate = self;
        _collectionView.userInteractionEnabled = NO;
    }
    return _collectionView;
}

-(void)showImageWithArray:(NSArray *)ar
{
    self.collectionView.dataArr = [ar mutableCopy];
}
@end
