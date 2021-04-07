//
//  QLShareImgBottomView.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/26.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLShareImgBottomView.h"

@implementation QLShareImgBottomView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLShareImgBottomView viewFromXib];
        self.downloadBtnWidth.constant = self.width*0.5;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
