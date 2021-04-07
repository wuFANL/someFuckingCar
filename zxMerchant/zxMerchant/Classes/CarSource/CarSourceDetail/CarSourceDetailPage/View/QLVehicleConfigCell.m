//
//  QLVehicleConfigCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/11.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLVehicleConfigCell.h"
#import "QLCollectionValueTextCell.h"

@interface QLVehicleConfigCell()<QLBaseCollectionViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@end
@implementation QLVehicleConfigCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:@"configCell"]) {
        //车配置信息
        [self addInfoView];

    }
    return self;
}
- (void)addInfoView {
    NSArray *titles = @[@"表显里程",@"首次上牌",@"档位 / 排量",@"环保标准",@"过户次数",@"车辆归属地",@"年检到期",@"强制险到期"];
    QLItemModel *model = [QLItemModel new];
    model.columnCount = 3;
    model.rowCount = ceil(titles.count/3.0);
    model.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
    model.Spacing = QLMinimumSpacingMake(10, 10);
    model.registerType = CellNibRegisterType;
    model.itemName = @"QLCollectionValueTextCell";
    QLBaseCollectionView *collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, model.rowCount*70) ItemModel:model];
    collectionView.dataArr = [NSMutableArray arrayWithArray:titles];
    collectionView.scrollEnabled = NO;
    collectionView.extendDelegate = self;
    [self.contentView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(model.rowCount*70);
    }];
    self.collectionView = collectionView;
}

#pragma mark -collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLCollectionValueTextCell class]]) {
        QLCollectionValueTextCell *item = (QLCollectionValueTextCell *)baseCell;
        item.titleLB.font = [UIFont boldSystemFontOfSize:14];
        item.detailLB.text = dataArr[indexPath.row];
        NSString *title = @"";
        item.titleLB.text = title;
    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    
}

@end
