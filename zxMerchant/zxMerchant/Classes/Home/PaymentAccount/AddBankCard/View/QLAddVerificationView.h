//
//  QLAddVerificationView.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/5/16.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLAddVerificationView : UIView
@property (weak, nonatomic) IBOutlet UILabel *accountLB;
@property (weak, nonatomic) IBOutlet UIView *tfView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

NS_ASSUME_NONNULL_END
