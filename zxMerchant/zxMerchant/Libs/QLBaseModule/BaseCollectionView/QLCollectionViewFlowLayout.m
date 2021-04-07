//
//  QLCollectionViewFlowLayout.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/9/28.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLCollectionViewFlowLayout.h"
@interface QLCollectionViewFlowLayout()
//可能为二维数组(当为多个section时) 或一维数组(当为1个section时)
@property (strong, nonatomic) NSMutableArray *itemFrames;
@property (strong, nonatomic) NSMutableArray *sectionFrames;
@property (strong, nonatomic) NSMutableArray *allAttributes;
//每一列的高度
@property (strong, nonatomic) NSMutableArray *columnHeights;
//没有生成大尺寸次数
@property (nonatomic, assign) NSInteger noneDoubleTime;
//最后一次大尺寸的列数
@property (nonatomic, assign) NSInteger lastDoubleIndex;
//最后一次对齐矫正列数
@property (nonatomic, assign) NSInteger lastFixIndex;

@end
@implementation QLCollectionViewFlowLayout
/*
 *规则布局初始化
 */
- (instancetype)initItemCount:(NSInteger)itemCount RowCount:(NSInteger)rowCount SectionInset:(UIEdgeInsets)sectionInset MinimumSpacing:(QLMinimumSpacing)Spacing {
    if (self = [super init]) {
        //初始化 布局相关的 设置
        self.columnCount = itemCount;
        self.rowCount = rowCount;
        self.minimumLineSpacing = Spacing.minimumLineSpacing;
        self.minimumInteritemSpacing = Spacing.minimumInteritemSpacing;
        self.sectionInset = sectionInset;
        
    }
    return self;
}
/*
 *外部设置大小的不规则布局初始化
 */
- (instancetype)initMinimumSpacing:(QLMinimumSpacing)Spacing
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = Spacing.minimumLineSpacing;
        self.minimumInteritemSpacing = Spacing.minimumInteritemSpacing;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    if (self.dataSource) {
        //Item不规则布局
        [self setUpItemsFrames];
    } else {
        if (self.showRandomSize&&self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            
            //随机Item大小布局
            NSInteger totalItem = 0;
            for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
                NSUInteger count = [self.collectionView numberOfItemsInSection:i];
                totalItem = totalItem + count;
            }
            if (totalItem < self.allAttributes.count) {
                //数据重置时
                [self.allAttributes removeAllObjects];
                [self.columnHeights removeAllObjects];
            } else if (self.allAttributes.count == 50) {
                //数据超过50条时
                [self.allAttributes removeAllObjects];
                [self.columnHeights removeAllObjects];
            }
            if (!self.columnHeights.count) {
                for (NSInteger i = 0; i < self.columnCount; i++) {
                    [self.columnHeights addObject:@(self.sectionInset.top)];
                }
            }
        } else {
            //默认布局
            [self.allAttributes removeAllObjects];
        }
        for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
            NSUInteger count = [self.collectionView numberOfItemsInSection:i];
            for (NSInteger j = self.allAttributes.count; j < count; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
                if (attributes) {
                    
                    [self.allAttributes addObject:attributes];
                }
            }
        }

    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [super layoutAttributesForItemAtIndexPath:indexPath];

    if (self.showRandomSize&&self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        
        // collectionView的宽度
        CGFloat collectionViewW = self.collectionView.frame.size.width;
        // cell的宽度
        CGFloat w = (collectionViewW - self.sectionInset.left - self.sectionInset.right -
                     self.minimumInteritemSpacing * (self.columnCount - 1)) / self.columnCount;
        // cell的高度
        NSUInteger randomOfHeight = arc4random() % 100;
        CGFloat h = w * (randomOfHeight >= 50 ? 250 : 320) / 200;
        // cell应该拼接的列数
        NSInteger destColumn = 0;
        // 高度最小的列数高度
        CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
        // 获取高度最小的列数
        for (NSInteger i = 1; i < self.columnCount; i++) {
            CGFloat columnHeight = [self.columnHeights[i] doubleValue];
            if (minColumnHeight > columnHeight) {
                minColumnHeight = columnHeight;
                destColumn = i;
            }
        }
        // 计算cell的x
        CGFloat x = self.sectionInset.left + destColumn * (w + self.minimumInteritemSpacing);
        // 计算cell的y
        CGFloat y = minColumnHeight;
        if (y != self.sectionInset.top) {
            CGFloat sectionTotalHeight = 0;
            if (self.sectionFrames.count != 0&&(self.sectionFrames.count > indexPath.section)) {
                for (int i = 0;i <= indexPath.section;i++) {
                    NSString *frameStr = self.sectionFrames[i];
                    CGRect rect = CGRectFromString(frameStr);
                    sectionTotalHeight = sectionTotalHeight+rect.size.height;
                }
            }
            y += (self.minimumLineSpacing+sectionTotalHeight);
        }
        // 随机数，用来随机生成大尺寸cell
        NSUInteger randomOfWhetherDouble = arc4random() % 100;
        // 判断是否放大
        if (destColumn < self.columnCount - 1
            // 放大的列数不能是最后一列（最后一列方法超出屏幕）
            && _noneDoubleTime >= 1
            // 如果前个cell有放大就不放大，防止连续出现两个放大
            && (randomOfWhetherDouble >= 45 || _noneDoubleTime >= 8)
            // 45%几率可能放大，如果累计8次没有放大，那么满足放大条件就放大
            && [self.columnHeights[destColumn] doubleValue] == [self.columnHeights[destColumn + 1] doubleValue]
            // 当前列的顶部和下一列的顶部要对齐
            && _lastDoubleIndex != destColumn) {
            // 最后一次放大的列不等当前列，防止出现连续两列出现放大不美观
            _noneDoubleTime = 0;
            _lastDoubleIndex = destColumn;
            // 重定义当前cell的布局:宽度*2,高度*2
            attrs.frame = CGRectMake(x, y, w * 2 + self.minimumLineSpacing, h * 2 + self.minimumLineSpacing);
            // 当前cell列的高度就是当前cell的最大Y值
            self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
            // 当前cell列下一列的高度也是当前cell的最大Y值，因为cell宽度*2,占两列
            self.columnHeights[destColumn + 1] = @(CGRectGetMaxY(attrs.frame));
        } else {
            // 正常cell的布局
            if (_noneDoubleTime <= 3 || _lastFixIndex == destColumn) {
                // 如果没有放大次数小于3且当前列等于上次矫正的列，就不矫正
                attrs.frame = CGRectMake(x, y, w, h);
            } else if (self.columnHeights.count > destColumn + 1                         // 越界判断
                       && y + h - [self.columnHeights[destColumn + 1] doubleValue] < w * 0.1) {
                // 当前cell填充后和上一列的高度偏差不超过cell最大高度的10%，就和下一列对齐
                attrs.frame = CGRectMake(x, y, w, [self.columnHeights[destColumn + 1] doubleValue] - y);
                _lastFixIndex = destColumn;
            } else if (destColumn >= 1                                                   // 越界判断
                       && y + h - [self.columnHeights[destColumn - 1] doubleValue] < w * 0.1) {
                // 当前cell填充后和上上列的高度偏差不超过cell最大高度的10%，就和下一列对齐
                attrs.frame = CGRectMake(x, y, w, [self.columnHeights[destColumn - 1] doubleValue] - y);
                _lastFixIndex = destColumn;
            } else {
                attrs.frame = CGRectMake(x, y, w, h);
            }
            // 当前cell列的高度就是当前cell的最大Y值
            self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
            _noneDoubleTime += 1;
        }
    } else if (self.dataSource&&self.scrollDirection==UICollectionViewScrollDirectionHorizontal) {
        attrs.frame = CGRectFromString(self.itemFrames[indexPath.section][indexPath.item]);
    } else if (self.showTransverseSortByHorizontal&&self.scrollDirection==UICollectionViewScrollDirectionHorizontal) {
        NSUInteger item = indexPath.item;
        NSUInteger x;
        NSUInteger y;
        [self targetPositionWithItem:item resultX:&x resultY:&y];
        NSUInteger theNewItem = [self originItemAtX:x y:y];
        NSIndexPath *theNewIndexPath = [NSIndexPath indexPathForItem:theNewItem inSection:indexPath.section];
        UICollectionViewLayoutAttributes *theNewAttr = [super layoutAttributesForItemAtIndexPath:theNewIndexPath];
        theNewAttr.indexPath = indexPath;
        return theNewAttr;
    }
    return attrs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (self.showCosineEffect&&self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
        NSMutableArray *tmp = [NSMutableArray array];
        for (UICollectionViewLayoutAttributes *attr in attributes) {
            for (UICollectionViewLayoutAttributes *attr2 in self.allAttributes) {
                if (attr.indexPath.item == attr2.indexPath.item) {
                    [tmp addObject:attr2];
                    break;
                }
            }
        }
        if (self.showCosineEffect) {
            //屏幕中线
            CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width/2.0f;
            //刷新cell缩放
            for (UICollectionViewLayoutAttributes *attributes in tmp) {
                CGFloat distance = fabs(attributes.center.x - centerX);
                //移动的距离和屏幕宽度的的比例
                CGFloat apartScale = distance/self.collectionView.bounds.size.width;
                //把卡片移动范围固定到 -π/4到 +π/4这一个范围内
                CGFloat scale = fabs(cos(apartScale * M_PI/4));
                //设置cell的缩放 按照余弦函数曲线 越居中越趋近于1
                attributes.transform = CGAffineTransformMakeScale(1.0, scale);
            }
        }
        
        return tmp;
    } else if (self.dataSource) {
        return self.allAttributes;
    } else if (self.showRandomSize&&self.scrollDirection == UICollectionViewScrollDirectionVertical) {
    
        NSMutableArray *temArr = [NSMutableArray array];
        //头部
        NSArray *sectionAtts = [super layoutAttributesForElementsInRect:rect];
        for (UICollectionViewLayoutAttributes *atts in sectionAtts) {
            if (![self.sectionFrames containsObject:NSStringFromCGRect(atts.frame)]) {
                [self.sectionFrames addObject:NSStringFromCGRect(atts.frame)];
            }
        }
        [temArr addObjectsFromArray:sectionAtts];
        //Item
        [temArr addObjectsFromArray:self.allAttributes];
    
        CGFloat sectionHeight = 0;
        if (sectionAtts.count != 0) {
            UICollectionViewLayoutAttributes *atts = sectionAtts.firstObject;
            sectionHeight = atts.frame.size.height;
        }
        CGFloat itemY = 0;
        if (self.allAttributes.count != 0) {
            UICollectionViewLayoutAttributes *atts = self.allAttributes.firstObject;
            itemY = atts.frame.origin.y;
        }
        if (itemY < sectionHeight) {
            for (UICollectionViewLayoutAttributes *atts in self.allAttributes) {
                atts.frame = CGRectMake(atts.frame.origin.x, atts.frame.origin.y+sectionHeight, atts.frame.size.width, atts.frame.size.height);
            }
        }

        return  temArr;
    }
    return [super layoutAttributesForElementsInRect:rect];
}
//下面两个方法分别返回Supplementary Views和Decoration Views布局信息
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource&&[self.collectionView supplementaryViewForElementKind:elementKind atIndexPath:indexPath]) {
        UICollectionViewLayoutAttributes *headerAtts = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        headerAtts.frame = CGRectFromString(self.sectionFrames[indexPath.section]);
        return headerAtts;
    }
    
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}
- (CGSize)collectionViewContentSize
{
    
    if (self.dataSource) {
        CGSize size = CGSizeZero;
        NSMutableArray *frames = self.itemFrames.lastObject;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            CGFloat lastItemMaxX = CGRectGetMaxX(CGRectFromString(frames.lastObject));
            size = CGSizeMake(lastItemMaxX > self.collectionView.bounds.size.width ? lastItemMaxX + self.sectionInset.left + self.sectionInset.right+1 :self.collectionView.bounds.size.width + 1, 0);
            
        } else {
            CGFloat lastItemMaxY = CGRectGetMaxY(CGRectFromString(frames.lastObject));
            size = CGSizeMake(0, lastItemMaxY > self.collectionView.bounds.size.height ? lastItemMaxY+ self.sectionInset.top + self.sectionInset.right+1:self.collectionView.bounds.size.height + 1);
        }
        
        return size;
    } else if (self.showRandomSize&&self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        // collectionView的contentSize的高度等于所有列高度中最大的值
        CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
        for (NSInteger i = 1; i < self.columnCount; i++) {
            CGFloat columnHeight = [self.columnHeights[i] doubleValue];
            if (maxColumnHeight < columnHeight) {
                maxColumnHeight = columnHeight;
            }
        }
        CGFloat headerHeight = 0;
        if (self.sectionFrames.count != 0) {
            NSString *frameStr = self.sectionFrames.firstObject;
            CGRect rect = CGRectFromString(frameStr);
            headerHeight = rect.size.height;
        }
        return CGSizeMake(0, maxColumnHeight + self.sectionInset.bottom + headerHeight);
    }
    return [super collectionViewContentSize];
}
//(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds布局对象信息发生改变时是否需要重新局部,建议return YES;
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
// 根据 item 计算目标item的位置
// x 横向偏移  y 竖向偏移
- (void)targetPositionWithItem:(NSUInteger)item resultX:(NSUInteger *)x resultY:(NSUInteger *)y {
    NSUInteger page = item/(self.columnCount*self.rowCount);
    NSUInteger theX = item % self.columnCount + page * self.columnCount;
    NSUInteger theY = item / self.columnCount - page * self.rowCount;
    if (x != NULL) {
        *x = theX;
    }
    if (y != NULL) {
        *y = theY;
    }
}

// 根据偏移量计算item
- (NSUInteger)originItemAtX:(NSUInteger)x
                          y:(NSUInteger)y
{
    NSUInteger item = x * self.rowCount + y;
    return item;
}
//不规则布局
- (void)setUpItemsFrames
{
    [self.sectionFrames removeAllObjects];
    [self.itemFrames removeAllObjects];
    [self.allAttributes removeAllObjects];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
        //分区大小
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:sectionCount];
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:sectionIndex];
        CGFloat sectionHeight = 1;
        if (self.dataSource&&[self.dataSource respondsToSelector:@selector(layout:sizeForSectionAtIndexPath:)]) {
            sectionHeight = [self.dataSource layout:self sizeForSectionAtIndexPath:sectionIndexPath].height;
        }
        if (sectionIndex == 0) {
            CGRect sectionFrame = CGRectMake(0, 0, self.collectionView.bounds.size.width, sectionHeight);
            [self.sectionFrames addObject:NSStringFromCGRect(sectionFrame)];
        } else {
            NSInteger lastItemCount = [self.collectionView numberOfItemsInSection:sectionIndex -1];
            CGRect lastItemFrame = CGRectFromString(self.itemFrames[sectionIndex - 1][lastItemCount -1]);
            CGRect sectionFrame = CGRectMake(0, CGRectGetMaxY(lastItemFrame), self.collectionView.bounds.size.width, sectionHeight);
            [self.sectionFrames addObject:NSStringFromCGRect(sectionFrame)];
        }
        
        //头尾大小
        UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
        att.frame = CGRectFromString(self.sectionFrames[sectionIndex]);
        [self.allAttributes addObject:att];
        
        //item大小
        NSMutableArray *mutableArr = [NSMutableArray array];
        for (int itemIndex = 0; itemIndex < itemCount; itemIndex++) {
            CGSize size = CGSizeZero;
            if (self.dataSource&&[self.dataSource respondsToSelector:@selector(layout:sizeForItemAtIndexPath:)]) {
                size = [self.dataSource layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex]];
            } else {
                size = self.itemSize;
            }
            
            if (itemIndex == 0) {
                CGRect sectionFrame = CGRectFromString(self.sectionFrames[sectionIndex]);
                [mutableArr addObject:NSStringFromCGRect(CGRectMake(self.sectionInset.left, CGRectGetMaxY(sectionFrame), size.width, size.height))];
            } else {
                CGRect lastFrame = CGRectFromString(mutableArr[itemIndex -1]);
                if ((CGRectGetMaxX(lastFrame) + self.minimumInteritemSpacing + size.width < self.collectionView.bounds.size.width)||self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                    [mutableArr addObject:NSStringFromCGRect(CGRectMake(CGRectGetMaxX(lastFrame) + self.minimumInteritemSpacing, CGRectGetMinY(lastFrame), size.width, size.height))];
                } else {
                    [mutableArr addObject:NSStringFromCGRect(CGRectMake(0, CGRectGetMaxY(lastFrame) + self.minimumLineSpacing, size.width, size.height))];
                }
            }
            UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex]];
            att.frame = CGRectFromString(mutableArr[itemIndex]);
            [self.allAttributes addObject:att];
        }
        [self.itemFrames addObject:mutableArr];
    }
}
#pragma mark- 懒加载
- (NSMutableArray *)sectionFrames
{
    if (!_sectionFrames) {
        _sectionFrames = [NSMutableArray array];
    }
    return _sectionFrames;
}

- (NSMutableArray *)itemFrames
{
    if (!_itemFrames) {
        _itemFrames = [NSMutableArray array];
    }
    return _itemFrames;
}
- (NSMutableArray *)allAttributes {
    if (!_allAttributes) {
        _allAttributes = [NSMutableArray array];
    }
    return _allAttributes;
}
- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
@end
