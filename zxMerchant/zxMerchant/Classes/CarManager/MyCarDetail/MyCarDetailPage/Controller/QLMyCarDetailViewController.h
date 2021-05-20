//
//  QLMyCarDetailViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/8.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLMyCarDetailViewController : QLBaseTableViewController
-(id)initWithUserid:(NSString *)userID carID:(NSString *)carId;
-(id)initWithUserid:(NSString *)userID carID:(NSString *)carId businessCarID:(NSString *)busCarID;
@end

NS_ASSUME_NONNULL_END
