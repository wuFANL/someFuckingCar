//
//  QLHomeCarCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/9/30.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLHomeCarCell.h"

@implementation QLHomeCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - setter
- (void)setAccType:(AccType)accType {
    _accType = accType;
    if (accType == AccTypeNew) {
        self.accImgView.hidden = NO;
        self.activityBjView.hidden = YES;
        self.accImgView.image = [UIImage imageNamed:@"new"];
    } else if (accType == AccTypeReduction) {
        self.accImgView.hidden = YES;
        self.activityBjView.hidden = NO;
        self.activityImgView.image = [UIImage imageNamed:@"activityBj"];
    } else {
        self.accImgView.hidden = YES;
        self.activityBjView.hidden = YES;
    }
}

@end
