//
//  QLAdvancedScreeningChooseCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLAdvancedScreeningChooseCell : UITableViewCell
/**
 *是否是选择车型
 */
@property (nonatomic, assign) BOOL isChooseModel;
/**
 *数据
 */
@property (nonatomic, strong) NSArray *dataArr;
/**
 *collectionView高度
 */
@property (nonatomic, assign) CGFloat collectionViewHeight;
/**
 *刷新回调
 */
@property (nonatomic, strong) resultBackBlock refreshandler;
@end

NS_ASSUME_NONNULL_END
