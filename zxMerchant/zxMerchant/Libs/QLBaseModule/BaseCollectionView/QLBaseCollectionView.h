//
//  QLBaseCollectionView.h
//  luluzhuan
//
//  Created by 乔磊 on 2017/9/28.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLCollectionViewFlowLayout.h"

typedef NS_ENUM(NSInteger, ITEM_REGISTER_TYPE) {
    ITEM_NibRegisterType = 0,//nib注册
    ITEM_ClassRegisterType = 1,//class注册
};
@class QLItemModel;
@interface QLItemModel : NSObject
/**
 *一行item个数
 */
@property (nonatomic, assign) NSInteger columnCount;
/**
 *行数
 */
@property (nonatomic, assign) NSInteger rowCount;
/**
 *分区间隔
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/**
 *item之间最小间距
 */
@property (nonatomic, assign) QLMinimumSpacing Spacing;
/**
 *item的size（为空时，自动设置大小）
 */
@property (nonatomic, assign) CGSize itemSize;
/**
 *滑动方向
 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
/**
 *item注册类型
 */
@property (nonatomic, assign) ITEM_REGISTER_TYPE registerType;
/**
 *item类名
 */
@property (nonatomic, strong) NSString * _Nullable itemName;
/**
 *是否显示余弦效果
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
@end


@class QLBaseCollectionView;
@protocol QLBaseCollectionViewDelegate <NSObject>
@optional
/*
 *分区代理
 */
- (NSInteger)numberOfSections:(UICollectionView *_Nonnull)collectionView;
- (NSInteger)collectionView:(UICollectionView *_Nonnull)collectionView numberOfItems:(NSInteger)section;
/*
 *item样式设置
 */
- (void)collectionView:(UICollectionView *_Nonnull)collectionView Item:(UICollectionViewCell *_Nonnull)baseCell IndexPath:(NSIndexPath *_Nonnull)indexPath Data:(NSMutableArray *_Nullable)dataArr;
/*
 *点击回调
 */
- (void)collectionViewSelect:(UICollectionView *_Nonnull)collectionView IndexPath:(NSIndexPath *_Nonnull)indexPath Data:(NSMutableArray *_Nullable)dataArr;
/*
 *分区头尾设置
 *@param kind  UICollectionElementKindSectionHeader和UICollectionElementKindSectionFooter
 *使用 UICollectionReusableView 需要注册
 */
- (UICollectionReusableView *_Nullable)collectionView:(UICollectionView *_Nonnull)collectionView viewKind:(NSString *_Nonnull)kind IndexPath:(NSIndexPath *_Nonnull)indexPath;
/*
 *分区头尾大小
 *@param kind  UICollectionElementKindSectionHeader和UICollectionElementKindSectionFooter
 */
- (CGSize)collectionView:(UICollectionView *_Nullable)collectionView layout:(UICollectionViewLayout *_Nullable)collectionViewLayout viewKind:(NSString *_Nonnull)kind InSection:(NSInteger)section;
/*
 *scrollView
 */
- (void)scrollViewEndScrollingAnimation:(UIScrollView *_Nonnull)scrollView;
- (void)scrollViewBeginDragging:(UIScrollView *_Nonnull)scrollView;
- (void)scrollViewEndDragging:(UIScrollView *_Nonnull)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewEndDecelerating:(UIScrollView *_Nonnull)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *_Nonnull)scrollView;
/**
 *刷新时方法
 */
- (void)loadNew;
- (void)loadMore;
/*
 *获得数据时候
 */
- (void)collectionView:(UICollectionView *_Nullable)collectionView GetData:(NSMutableArray *_Nullable)dataArr;
/**
 *数据请求方法
 */
- (void)dataRequest;
@end

@interface QLBaseCollectionView : UICollectionView <UICollectionViewDelegate,UICollectionViewDataSource>
/**
 *初始化(不适用于不规则布局)
 */
- (instancetype _Nonnull )initWithSize:(CGSize)size ItemModel:(QLItemModel *_Nonnull)itemModel;
- (instancetype _Nonnull )initWithFrame:(CGRect)frame ItemModel:(QLItemModel *_Nonnull)itemModel;
/*
 *初始化布局
 */
- (QLCollectionViewFlowLayout *_Nullable)layoutWithFrame:(CGRect)frame ItemModel:(QLItemModel *_Nonnull)itemModel;
/*
 *布局模型
 */
@property (nonatomic, strong) QLItemModel * _Nonnull itemModel;
/**
 *页数
 */
@property (nonatomic, assign) NSInteger page;
/**
 *是否添加头部刷新
 */
@property (nonatomic, assign) BOOL showHeadRefreshControl;
/**
 *是否添加底部部刷新
 */
@property (nonatomic, assign) BOOL showFootRefreshControl;
/**
 *数据
 */
@property (nonatomic, strong) NSMutableArray *_Nullable dataArr;
/**
 *注册cell类型(0：Nib 1:Class)
 */
@property (nonatomic, assign) ITEM_REGISTER_TYPE registerType;
/**
 *cell类名
 */
@property (nonatomic, strong) NSString * _Nonnull cellClassName;
/**
 *设置代理
 */
@property (nonatomic, weak) id<QLBaseCollectionViewDelegate>_Nullable extendDelegate;

@end
