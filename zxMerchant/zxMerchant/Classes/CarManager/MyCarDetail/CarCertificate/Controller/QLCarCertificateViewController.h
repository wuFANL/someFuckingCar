//
//  QLCarCertificateViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/15.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLCarCertificateViewController : QLViewController
-(id)initWithArray:(NSArray *)ar;
@property (nonatomic, strong) NSString *carID;
@end

NS_ASSUME_NONNULL_END
