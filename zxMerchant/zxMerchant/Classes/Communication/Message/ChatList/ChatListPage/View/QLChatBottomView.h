//
//  QLChatBottomView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/9.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLChatBottomView : UIView
@property (weak, nonatomic) IBOutlet UIView *funView;
@property (weak, nonatomic) IBOutlet QLBaseTextView *tv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeight;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (nonatomic, copy) NSArray *funArr;
@property (nonatomic, strong) ResultBlock clickHandler;

@end

NS_ASSUME_NONNULL_END
