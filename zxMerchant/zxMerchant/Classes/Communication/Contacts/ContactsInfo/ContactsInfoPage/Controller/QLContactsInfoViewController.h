//
//  QLContactsInfoViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/7.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,ContactRelation) {
    Stranger = 0,
    Friend = 1,
};
@interface QLContactsInfoViewController : QLBaseTableViewController

-(id)initWithFirendID:(NSString *)firendID;
/**
 *联系人关系
 */
@property (nonatomic, assign) ContactRelation contactRelation;
@end

NS_ASSUME_NONNULL_END
