//
//  QLCarCircleImgCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/26.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarCircleImgCell.h"
#import "QLCarCircleImgItem.h"
#import "QLFullScreenImgView.h"
#import "QLRidersDynamicListModel.h"

@interface QLCarCircleImgCell()<QLBaseCollectionViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;

@end
@implementation QLCarCircleImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
#pragma mark - setter
- (void)setCollectionViewHeight:(CGFloat)collectionViewHeight {
    _collectionViewHeight = collectionViewHeight;
    
    if (self.bjViewHeight.constant != self.collectionViewHeight && self.collectionViewHeight != 0) {
        self.bjViewHeight.constant = self.collectionViewHeight;
    }
}
//设置数据
- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    
    self.collectionView.dataArr = dataArr;
}
//设置数据类型
- (void)setDataType:(QLCarCircleDataType)dataType {
    _dataType = dataType;
    
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
    //增加collectionView
    [self.bjView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bjView);
    }];
}
#pragma mark - collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLCarCircleImgItem class]]) {
        QLCarCircleImgItem *item = (QLCarCircleImgItem *)baseCell;
        item.playBtn.hidden = self.dataType==ImageType?YES:NO;
        id obj = dataArr[indexPath.row];
        if ([obj isKindOfClass:[NSDictionary class]]&&[(NSDictionary *)obj objectForKey:@"pic_url"]) {
            NSString *url = [NSString stringWithFormat:@"%@",[(NSDictionary *)obj objectForKey:@"pic_url"]];
            [item.imgView sd_setImageWithURL:[NSURL URLWithString:url]];
        } else if ([obj isKindOfClass:[QLRidersDynamicFileModel class]]) {
            QLRidersDynamicFileModel *model = obj;
            [item.imgView sd_setImageWithURL:[NSURL URLWithString:model.file_url]];
        }
        
        
    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    // 图片放大
    UICollectionViewCell *baseCell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([baseCell isKindOfClass:[QLCarCircleImgItem class]]) {
        QLCarCircleImgItem *item = (QLCarCircleImgItem *)baseCell;
        if (item.imgView.image) {
            QLFullScreenImgView *fsiView = [QLFullScreenImgView new];
            fsiView.img = item.imgView.image;
            [fsiView show];
        }
    }
}


//属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]&&[object isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)object;
        CGFloat heigth  = collectionView.collectionViewLayout.collectionViewContentSize.height;
        
        
        if (![[NSString stringWithFormat:@"%.0f",self.bjViewHeight.constant] isEqualToString:[NSString stringWithFormat:@"%.0f",heigth]]) {
            self.bjViewHeight.constant = heigth;
            self.collectionViewHeight = heigth;
            if (self.heightHandler) {
                self.heightHandler(@(heigth));
            }
           
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
        QLItemModel *model = [QLItemModel new];
        model.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        if (self.dataType == ImageType) {
            model.Spacing = QLMinimumSpacingMake(10, 10);
            model.columnCount = 3;
            CGFloat width = (self.bjView.width-(model.Spacing.minimumLineSpacing*(model.columnCount-1)))/model.columnCount;
            model.itemSize = CGSizeMake(width, width);
        } else {
            model.Spacing = QLMinimumSpacingMake(15, 15);
            model.columnCount = 2;
            CGFloat width = (self.bjView.width-(model.Spacing.minimumLineSpacing*(model.columnCount-1)))/model.columnCount;
            model.itemSize = CGSizeMake(width, width*0.75);
        }
        model.registerType = ITEM_NibRegisterType;
        model.itemName = @"QLCarCircleImgItem";
        model.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[QLBaseCollectionView alloc]initWithFrame:self.bjView.frame ItemModel:model];
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.extendDelegate = self;
        [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _collectionView;
}

@end
