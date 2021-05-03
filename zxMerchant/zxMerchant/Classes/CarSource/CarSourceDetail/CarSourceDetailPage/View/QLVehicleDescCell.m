//
//  QLVehicleDescCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/12.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLVehicleDescCell.h"

@implementation QLVehicleDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithDic:(NSDictionary *)dic {
    
    if (dic && [dic objectForKey:@"car_param"]) {
        NSString *car_desc = EncodeStringFromDic([dic objectForKey:@"car_param"], @"car_desc");
        self.contentLB.text = car_desc;
        NSString *vieoUrl = EncodeStringFromDic([dic objectForKey:@"car_param"], @"car_video");
        if (vieoUrl.length > 0) {
            // 有视频
            self.firstFramePic.image = [UIImage videoFramerateWithPath:vieoUrl];
           // self.uploadControl.hidden = NO;
        } else {
           // self.uploadControl.hidden = YES;
        }
    }
}

@end
