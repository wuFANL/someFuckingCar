//
//  QLAppointmentCountView.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/10/19.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLAppointmentCountView : QLBaseView
/**
 *结果回调
 */
@property (nonatomic, strong) ResultBlock result;
- (void)show;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
