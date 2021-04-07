//
//  QLBadgeButton.m
//  
//
//  Created by 乔磊 on 12-4-2.
//  Copyright (c) 2012年. All rights reserved.
//

#import "QLBadgeButton.h"
#import "NSString+QLUtil.h"

#define badgeImageName @"badge"

@interface QLBadgeButton()
@property (nonatomic, assign) NSInteger startValue;
@end
@implementation QLBadgeButton

- (instancetype)init {
    
    if (self = [super init]) {
        self.hidden = YES;
        [self setBackgroundImage:[UIImage imageNamed:badgeImageName] forState:UIControlStateNormal];
        self.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.startValue = 0;
        
    }
    return self;
}

- (void)setShowNum:(BOOL)showNum {
    _showNum = showNum;
    NSString *tem = self.badgeValue;
    _badgeValue = tem;
}
- (void)setBadgeValue:(NSString *)badgeValue {
    
    _badgeValue = [badgeValue copy];
    
    if (badgeValue && (badgeValue.integerValue > self.startValue)) {
        self.hidden = NO;
        // 设置文字
        if (self.showNum) {
            [self setTitle:badgeValue forState:UIControlStateNormal];
        }
        
    } else {
        self.hidden = YES;
    }
}
- (void)setHighlighted:(BOOL)highlighted {
    
}
@end
