//
//  QLCarDescViewController.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/15.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLCarDescViewController : QLViewController

-(id)initWithDic:(NSDictionary *)dic;
@property (nonatomic, strong) NSString *carID;
/**
 *视频地址
 */
@property (nonatomic, strong) NSString *car_video;
@end

NS_ASSUME_NONNULL_END
