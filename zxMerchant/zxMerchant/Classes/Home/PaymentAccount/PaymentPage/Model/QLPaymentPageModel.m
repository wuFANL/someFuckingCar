//
//  QLPaymentPageModel.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/8/6.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLPaymentPageModel.h"

@implementation QLPaymentPageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"bank_list" : [QLBankModel class],
             };
}
@end

@implementation QLMerchantAccountModel

@end

@implementation QLBankModel

@end
