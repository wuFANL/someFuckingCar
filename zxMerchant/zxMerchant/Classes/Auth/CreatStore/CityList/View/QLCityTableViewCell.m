//
//  QLCityTableViewCell.m
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/5/31.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLCityTableViewCell.h"
#import "QLCityLocationItem.h"
@interface QLCityTableViewCell() <QLBaseCollectionViewDelegate>
@property (nonatomic, weak) QLBaseCollectionView *collectionView;

@end
@implementation QLCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.model.region_list.count > 0) {
        [self.collectionView removeFromSuperview];
        self.collectionView = nil;
        QLItemModel *model = [QLItemModel new];
        model.columnCount = 5;
        model.rowCount = self.model.region_list.count/model.columnCount+(self.model.region_list.count%model.columnCount==0?0:1);
        model.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
        model.Spacing = QLMinimumSpacingMake(10, 10);
        model.registerType = CellNibRegisterType;
        model.itemName = @"QLCityLocationItem";
        
        QLBaseCollectionView *collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectMake(0, 25, ScreenWidth, self.height-25) ItemModel:model];
        collectionView.extendDelegate = self;
        collectionView.tag = self.tag;
        collectionView.dataArr = [NSMutableArray arrayWithArray:self.model.region_list];
        [self.contentView addSubview:collectionView];
        self.collectionView = collectionView;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.titleLB.mas_bottom);
        }];
    }
    
}
- (void)setModel:(QLCityListModel *)model {
    _model = model;
    self.titleLB.text = model.group_name;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
//设置Item
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLCityLocationItem class]]) {
        QLCityLocationItem *item = (QLCityLocationItem *)baseCell;
        QLRegionListModel *model = dataArr[indexPath.row];
        [item.titleBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        [item.titleBtn setTitle:model.region_name forState:UIControlStateNormal];
        [item.titleBtn setBackgroundImage:[UIImage imageNamed:@"cityChoose"] forState:UIControlStateNormal];
        [item.titleBtn setBackgroundImage:[UIImage imageNamed:@"cityChoose_Selected"] forState:UIControlStateSelected];
        if ([self.titleLB.text isEqualToString:@"当前定位"]) {
            item.titleBtn.selected = YES;
        } else {
            item.titleBtn.selected = NO;
        }
    }
}
//点击Item
- (void)selectEvent:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath {
    self.selectedBlock(collectionView.tag, indexPath.row);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
