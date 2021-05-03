//
//  QLVehicleDescCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/12.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLVehicleDescCell : UITableViewCell
// 图片 播放器
@property (weak, nonatomic) IBOutlet UIControl *uploadControl;
// 车辆描述
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIImageView *firstFramePic;

- (void)updateWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
