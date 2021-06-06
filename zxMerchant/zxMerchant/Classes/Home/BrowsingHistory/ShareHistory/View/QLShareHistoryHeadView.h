//
//  QLShareHistoryHeadView.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/30.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLShareHistoryHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalNumLB;
@property (weak, nonatomic) IBOutlet UILabel *todayNumLB;
@property (weak, nonatomic) IBOutlet UILabel *visitorsNumLB;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@end

NS_ASSUME_NONNULL_END
