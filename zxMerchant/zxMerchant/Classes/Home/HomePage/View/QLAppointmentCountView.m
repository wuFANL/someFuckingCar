//
//  QLAppointmentCountView.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/10/19.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLAppointmentCountView.h"
@interface QLAppointmentCountView()<QLBaseViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UITextField *countTF;

@end
@implementation QLAppointmentCountView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLAppointmentCountView viewFromXib];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.frame = [UIScreen mainScreen].bounds;
        self.viewDelegate = self;
    }
    return self;
}
- (IBAction)submitBtnClick:(id)sender {
    [self hidden];
    self.result(self.countTF.text, nil);
}
- (IBAction)closeBtnClick:(id)sender {
    [self hidden];
}
- (void)show {
    [KeyWindow addSubview:self];
}
- (void)hidden {
    [self removeFromSuperview];
}
- (void)hideMaskViewEvent {
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
