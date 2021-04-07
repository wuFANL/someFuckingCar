//
//  QLHorizontalScrollCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/1.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLHorizontalScrollCell : UITableViewCell
/**
 *collectionView布局
 */
@property (nonatomic, strong) QLItemModel *itemModel;
/**
 *collectionView高度
 */
@property (nonatomic, assign) CGFloat collectionViewHeight;
/**
 *数据
 */
@property (nonatomic, copy) NSArray *itemArr;
/**
 *设置item
 */
@property (nonatomic, strong) ResultBlock itemSetHandler;
/**
 *item点击
 */
@property (nonatomic, strong) ResultBlock itemSelectHandler;
@end

NS_ASSUME_NONNULL_END
