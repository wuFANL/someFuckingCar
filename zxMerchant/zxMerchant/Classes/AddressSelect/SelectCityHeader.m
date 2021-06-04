//
//  SelectCityHeader.m
//  zxMerchant
//
//  Created by 张精申 on 2021/6/5.
//  Copyright © 2021 ql. All rights reserved.
//

#import "SelectCityHeader.h"

@implementation SelectCityHeader
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth, 50)];
        
        [self addSubview:self.titleLabel];
    }
    return self;
}
@end
