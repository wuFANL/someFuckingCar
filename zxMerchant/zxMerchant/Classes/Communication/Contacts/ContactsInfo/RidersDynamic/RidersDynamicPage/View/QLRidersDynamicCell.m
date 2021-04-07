//
//  QLRidersDynamicCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/30.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLRidersDynamicCell.h"
#import "QLRidersDynamicImgItem.h"

@interface QLRidersDynamicCell()<QLBaseCollectionViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;

@end
@implementation QLRidersDynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - setter
- (void)setDataType:(DynamicDataType)dataType {
    _dataType = dataType;
    if (dataType == NoDynamicData) {
        self.titleLB.text = @"";
        self.numLB.text = @"";
        
        self.imgArr = @[@"CameraIcon_white"];
    } else {
        self.imgArr = self.imgArr;
    }
}
- (void)setImgArr:(NSArray *)imgArr {
    _imgArr = imgArr;
    
    if (imgArr.count != 0) {
        [self addCollectionView];
    }
}
#pragma mark - collectionView
- (void)addCollectionView {
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
    
    NSInteger count = self.imgArr.count;
    QLItemModel *model = [QLItemModel new];
    model.rowCount = count<=2?1:2;
    model.columnCount = count==1?1:2;
    model.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    model.Spacing = QLMinimumSpacingMake(2, 2);
    model.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    model.itemName = @"QLRidersDynamicImgItem";
    model.registerType = CellNibRegisterType;
    
    self.collectionView = [[QLBaseCollectionView alloc] initWithFrame:self.imgBjView.bounds ItemModel:model];
    self.collectionView.userInteractionEnabled = self.dataType==NoDynamicData?YES:NO;
    self.collectionView.extendDelegate = self;
    self.collectionView.dataArr = [self.imgArr mutableCopy];
    [self.imgBjView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imgBjView);
    }];
}
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLRidersDynamicImgItem class]]) {
        QLRidersDynamicImgItem *item = (QLRidersDynamicImgItem *)baseCell;
        item.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if (self.dataType == NoDynamicData) {
            item.cameraIconImgView.hidden = NO;
        } else if (self.dataType == VideoDynamic) {
            item.iconImgView.hidden = NO;
        }
    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    
}
@end
