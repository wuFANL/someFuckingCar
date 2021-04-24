//
//  QLPCAListViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2021/4/22.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLViewController.h"

NS_ASSUME_NONNULL_BEGIN
/**
 *省市区 选择
 */

typedef void (^SelectedLocationBlock) (NSDictionary *);
@interface QLPCAListViewController : QLViewController
@property (nonatomic, copy) SelectedLocationBlock selectedBlock;

@end

NS_ASSUME_NONNULL_END
