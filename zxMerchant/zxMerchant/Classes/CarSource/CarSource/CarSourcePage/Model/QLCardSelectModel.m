//
//  QLCardSelectModel.m
//  zxMerchant
//
//  Created by wufan on 2021/6/14.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLCardSelectModel.h"

@implementation QLCardSelectModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.vehicle_age = @[@"不限",@"0-6年",@"6-10年",@"10-15年",@"15年以上"];
        self.car_type = @[@"不限",@"两厢轿车",@"三厢轿车",@"跑车",@"SUV",@"MPV",@"面包车",@"皮卡"];
        self.priceArea = @[@"不限",@"5万以内",@"5万-10万",@"10万-15万",@"15万-20万",@"20万-30万",@"30万-50万",@"50万以上"];
        self.driving_distance = @[@"不限",@"0-5万公里",@"5-10万公里",@"10-15万公里",@"15-20万公里",@"20万公里以上"];
    }
    return self;
}
@end
