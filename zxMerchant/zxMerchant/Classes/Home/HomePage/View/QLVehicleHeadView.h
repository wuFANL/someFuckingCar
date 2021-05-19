//
//  QLVehicleHeadView.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/9/22.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QLVehicleHeadView;
@protocol QLVehicleHeadViewDelegate <NSObject>
@optional
- (void)selectTypeBack:(NSInteger)type;
@end
@interface QLVehicleHeadView : UIView
@property (weak, nonatomic) IBOutlet UIView *typeView;
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
@property (nonatomic, weak) id<QLVehicleHeadViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
