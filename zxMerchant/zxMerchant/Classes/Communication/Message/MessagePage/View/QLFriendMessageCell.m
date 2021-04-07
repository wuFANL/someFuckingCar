//
//  QLFriendMessageCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/6.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLFriendMessageCell.h"

@implementation QLFriendMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView roundRectCornerRadius:4 borderWidth:1 borderColor:ClearColor];
    [self.badgeLB roundRectCornerRadius:12*0.5 borderWidth:1 borderColor:ClearColor];
    self.badgeValue = 0;
}
#pragma mark - setter
- (void)setBadgeValue:(NSInteger)badgeValue {
    _badgeValue = badgeValue;
    if (badgeValue <= 0) {
        self.badgeLB.text = @"";
        self.badgeLB.hidden = YES;
    } else {
        self.badgeLB.text = [NSString stringWithFormat:@"%ld",(long)badgeValue];
        self.badgeLB.hidden = NO;
    }
}

@end
