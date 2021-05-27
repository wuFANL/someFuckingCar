//
//  QLMyCarDetailBottomView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/10.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLMyCarDetailBottomView : UIView
@property (weak, nonatomic) IBOutlet UIControl *openControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openControlLeft;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLB;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
-(void)defaultOpen;
@end

NS_ASSUME_NONNULL_END
