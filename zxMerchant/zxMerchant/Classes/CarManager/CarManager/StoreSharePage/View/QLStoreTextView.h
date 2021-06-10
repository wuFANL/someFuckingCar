//
//  QLStoreTextView.h
//  zxMerchant
//
//  Created by lei qiao on 2021/6/8.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLStoreTextView : QLBaseView
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *tvBjView;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIButton *fzBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *pyqBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, strong) ResultBlock handler;
- (void)show;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
