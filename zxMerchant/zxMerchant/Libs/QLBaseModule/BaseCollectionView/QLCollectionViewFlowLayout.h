//
//  QLCollectionViewFlowLayout.h
//  luluzhuan
//
//  Created by 乔磊 on 2017/9/28.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef struct CG_BOXABLE QLMinimumSpacing QLMinimumSpacing;
struct QLMinimumSpacing {
    CGFloat minimumLineSpacing;
    CGFloat minimumInteritemSpacing;
};
CG_INLINE QLMinimumSpacing
QLMinimumSpacingMake(CGFloat minimumLineSpacing, CGFloat minimumInteritemSpacing) {
    QLMinimumSpacing spacing;
    spacing.minimumLineSpacing = minimumLineSpacing;
    spacing.minimumInteritemSpacing = minimumInteritemSpacing;
    return spacing;
}
@class QLCollectionViewFlowLayout;
@protocol QLIrregularLayoutDataSource <NSObject>
@optional
/**
 *获取section的大小
 */
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForSectionAtIndexPath:(NSIndexPath *)indexPath;
/**
 *获取item的大小
 */
- (CGSize)layout:(QLCollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface QLCollectionViewFlowLayout : UICollectionViewFlowLayout
/*
 *初始化（外部设置大小的不规则布局）
 *@param QLMinimumSpacing (Item 距离)
 */
- (instancetype)initMinimumSpacing:(QLMinimumSpacing)Spacing;
/**
 *初始化
 *@param itemCount 一行中 cell的个数
 *@param rowCount 一页显示多少行
 */
- (instancetype)initItemCount:(NSInteger)itemCount RowCount:(NSInteger)rowCount SectionInset:(UIEdgeInsets)sectionInset MinimumSpacing:(QLMinimumSpacing)Spacing;
/**
 *是否有余弦动画效果
 */
@property (nonatomic, assign) BOOL showCosineEffect;
/**
 *是否有随机大小的布局效果
 */
@property (nonatomic, assign) BOOL showRandomSize;
/**
 *是否有水平滑动横向排序效果
 */
@property (nonatomic, assign) BOOL showTransverseSortByHorizontal;
/**
 *一行中 cell的个数
 */
@property (nonatomic) NSUInteger columnCount;
/**
 *一页显示多少行
 */
@property (nonatomic) NSUInteger rowCount;
/*
 *不规则布局代理
 */
@property (nonatomic, weak) id<QLIrregularLayoutDataSource> dataSource; 
@end
