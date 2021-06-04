//
//  QLShareAlertView.m
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/4/2.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLShareAlertView.h"
@interface QLShareAlertView()<QLBaseViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewBottom;

@end
@implementation QLShareAlertView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLShareAlertView viewFromXib];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.frame = [UIScreen mainScreen].bounds;
        self.alertView.width = ScreenWidth;
        self.alertViewBottom.constant = ScreenHeight;
        self.viewDelegate = self;
        
        self.headImgView.image = self.headImgView.image?self.headImgView.image:[UIImage imageNamed:@"icon"];
        [self.coBtn roundRectCornerRadius:15*0.5 borderWidth:1 borderColor:ClearColor];
    }
    return self;
}
#pragma mark - action
- (IBAction)channelBtnClick:(UIButton *)sender {
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
- (IBAction)coBtnClick:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.descLB.text;
    [MBProgressHUD showSuccess:@"复制成功!"];
}
- (IBAction)cancelBtnClick:(id)sender {
    [self hidden];
}
- (void)show {
    [KeyWindow addSubview:self];
    [UIView animateWithDuration:animationDuration animations:^{
        self.alertViewBottom.constant = 0;
        [self layoutIfNeeded];
    }];
}
- (void)hidden {
    [UIView animateWithDuration:animationDuration animations:^{
        self.alertViewBottom.constant = ScreenHeight;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
- (void)hiddenViewEvent {
    [self hidden];
}
@end
