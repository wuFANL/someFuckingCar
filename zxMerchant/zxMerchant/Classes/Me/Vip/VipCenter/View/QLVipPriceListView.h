//
//  QLVipPriceListView.h
//  zxMerchant
//
//  Created by lei qiao on 2021/1/10.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLVipPriceListView : QLBaseView
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIView *tfView;
@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (nonatomic, strong) QLBaseCollectionView *collectionView;

/** data*/
@property (nonatomic, strong) NSMutableArray *zdataArr;
// 当前选中的下标
@property (nonatomic, assign) NSInteger selectIndex;
@end

NS_ASSUME_NONNULL_END
