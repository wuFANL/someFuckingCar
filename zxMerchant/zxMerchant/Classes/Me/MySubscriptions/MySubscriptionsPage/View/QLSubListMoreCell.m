//
//  QLSubListMoreCell.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/28.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLSubListMoreCell.h"

@implementation QLSubListMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithDic:(NSDictionary *)dic {
    self.timeLB.text = EncodeStringFromDic(dic, @"create_time");
//    self.accLB.text = EncodeStringFromDic(dic, @"");
    NSArray *arr = [dic objectForKey:@"car_list"];
    if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
        self.accLB.text = [NSString stringWithFormat:@"查看全部%lu辆",(unsigned long)arr.count];
    } else {
        self.accLB.text = @"暂无符合条件的车辆";
    }
}

@end
