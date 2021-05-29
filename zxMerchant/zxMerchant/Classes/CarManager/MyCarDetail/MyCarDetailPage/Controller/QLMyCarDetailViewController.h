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
//车辆管理
-(id)initWithUserid:(NSString *)userID carID:(NSString *)carId businessCarID:(NSString *)busCarID;

@property (nonatomic, strong) NSString *refuseStr;

@property (nonatomic, strong) NSString *bottomType;
@property (nonatomic, strong) NSString *bottomBtnTitle;
@end

NS_ASSUME_NONNULL_END
