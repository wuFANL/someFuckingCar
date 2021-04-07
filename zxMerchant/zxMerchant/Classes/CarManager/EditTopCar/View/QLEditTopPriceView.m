//
//  QLEditTopPriceView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/12/7.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLEditTopPriceView.h"
@interface QLEditTopPriceView()<QLBaseViewDelegate>

@end
@implementation QLEditTopPriceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLEditTopPriceView viewFromXib];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.viewDelegate = self;
        
        [self.alertView roundRectCornerRadius:4 borderWidth:1 borderColor:ClearColor];
        
        [self.tfView roundRectCornerRadius:2 borderWidth:1 borderColor:[UIColor groupTableViewBackgroundColor]];
        self.textField.borderStyle = UITextBorderStyleNone;
        
        [self.txtView roundRectCornerRadius:2 borderWidth:1 borderColor:[UIColor groupTableViewBackgroundColor]];
        self.txtView.placeholder = @"车辆的基础数据,可修改:车辆品牌、车系、车型、VIN码、表显里程、过户次数、排量、变速箱、车身颜色";
        self.txtView.showCountLimit = NO;
    }
    return self;
}
#pragma mark - action
- (IBAction)cancelBtnClick:(id)sender {
    [self hidden];
}
- (void)show {
    self.frame = [UIScreen mainScreen].bounds;
    [KeyWindow addSubview:self];
    
}
- (void)hidden {
    [self removeFromSuperview];
}
- (void)hiddenViewEvent {
   
}
@end
