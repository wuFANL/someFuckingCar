//
//  QLVehicleSortView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/22.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QLVehicleSortView;
@protocol QLVehicleSortViewDelegate <NSObject>
@optional
- (void)selectTypeBack:(NSInteger)type;

@end
@interface QLVehicleSortView : UIView
/*
 *选中下标
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *是否显示警告标志
 */
@property (nonatomic, assign) BOOL showWarn;
/**
 *是否显示状态
 */
@property (nonatomic, assign) BOOL showStatusItem;
/**
 *是否显示筛选
 */
@property (nonatomic, assign) BOOL showScreenItem;
/**
 *是否还原选择项
 */
@property (nonatomic, assign) BOOL showOriginalItem;
/**
 *当前显示数据
 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/*
 *collectionView
 */
@property (nonatomic, weak) QLBaseCollectionView *collectionView;
/**
 *代理
 */
@property (nonatomic, weak) id<QLVehicleSortViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
