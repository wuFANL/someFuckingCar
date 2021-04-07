//
//  QLCustomAlertView.m
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2018/11/12.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLCustomAlertView.h"

@implementation QLCustomAlertView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLCustomAlertView viewFromXib];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self.alertView roundRectCornerRadius:3 borderWidth:1 borderColor:ClearColor];
        [self.tfView roundRectCornerRadius:3 borderWidth:1 borderColor:[UIColor groupTableViewBackgroundColor]];
        self.editTF.borderStyle = UITextBorderStyleNone;
        self.showTF = NO;
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
}
- (void)setShowTF:(BOOL)showTF {
    _showTF = showTF;
    if (showTF) {
        self.tfView.hidden = NO;
        self.tfViewHeight.constant = 44;
    } else {
        self.tfView.hidden = YES;
        self.tfViewHeight.constant = 0;
    }
}
- (IBAction)cancelBtnClick:(id)sender {
    
    NSError *error = [NSError errorWithDomain:@"取消" code:-1 userInfo:nil];
    self.result(nil, error);
    [self hidden];
}
- (IBAction)confirmBtnClick:(id)sender {
    
    self.result(self.editTF.text, nil);
    [self hidden];
}
- (void)show {
    [self removeFromSuperview];
    [KeyWindow addSubview:self];
}
- (void)hidden {
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
