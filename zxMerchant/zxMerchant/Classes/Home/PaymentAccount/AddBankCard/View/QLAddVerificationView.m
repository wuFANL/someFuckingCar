//
//  QLAddVerificationView.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/5/16.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLAddVerificationView.h"

@implementation QLAddVerificationView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLAddVerificationView viewFromXib];
        self.codeTF.borderStyle = UITextBorderStyleNone;
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
