//
//  QLContactsStoreViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLContactsStoreViewController : QLBaseTableViewController
-(id)initWithDic:(NSDictionary *)dic;
/**
 *导航栏标题
 */
@property (nonatomic, copy) NSString *naviTitle;

@end

NS_ASSUME_NONNULL_END
