//
//  QLStoreTextView.m
//  zxMerchant
//
//  Created by lei qiao on 2021/6/8.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLStoreTextView.h"
@interface QLStoreTextView()<QLBaseViewDelegate>

@end
@implementation QLStoreTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLStoreTextView viewFromXib];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.viewDelegate = self;
        
        [self.tvBjView roundRectCornerRadius:5 borderWidth:1 borderColor:LightGrayColor];
    }
    return self;
}
- (IBAction)fzBtnClick:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.contentTV.text;
    [MBProgressHUD showSuccess:@"复制成功!"];
}
- (IBAction)shareBtnClick:(UIButton *)sender {
    NSInteger index = sender.tag;
    UMSocialPlatformType platformType = UMSocialPlatformType_UnKnown;
    if (index == 0) {
        //微信
        platformType = UMSocialPlatformType_WechatSession;
    } else {
        //朋友圈
        platformType = UMSocialPlatformType_WechatTimeLine;
    }
    self.handler(@(platformType), nil);
    [self hidden];
}
- (IBAction)cancelBtnClick:(id)sender {
    [self  hidden];
}

- (void)show {
    self.frame = [UIScreen mainScreen].bounds;
    [KeyWindow addSubview:self];
    
}
- (void)hidden {
    [self removeFromSuperview];
}
- (void)hiddenViewEvent {
    [self  hidden];
}
@end
