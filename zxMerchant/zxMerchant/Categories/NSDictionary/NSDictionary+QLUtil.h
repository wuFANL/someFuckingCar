//
//  NSDictionary+QLUtil.h
//  zxMerchant
//
//  Created by lei qiao on 2021/4/22.
//  Copyright © 2021 ql. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (QLUtil)
/**
 *字典去除null
 */
- (NSDictionary *)deleteNull;
@end

NS_ASSUME_NONNULL_END
