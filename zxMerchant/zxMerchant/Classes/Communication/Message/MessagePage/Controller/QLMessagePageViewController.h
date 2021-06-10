//
//  QLMessagePageViewController.h
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/20.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^NMessageHeaderBlock) (NSDictionary *messageDic);
@interface QLMessagePageViewController : QLBaseTableViewController
@property (nonatomic, copy) NMessageHeaderBlock msgBlock;
-(void)carCricleBackToReload;
@end

NS_ASSUME_NONNULL_END
