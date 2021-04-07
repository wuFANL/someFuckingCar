//
//  QLUnbindStoreView.h
//  zxMerchant
//
//  Created by lei qiao on 2021/1/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLUnbindStoreView : QLBaseView
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIView *tfView;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

- (void)show;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
