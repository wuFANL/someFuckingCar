//
//  QLDynamicSendMsgBottomView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLDynamicSendMsgBottomView : UIView
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet QLBaseButton *sendBtn;

@property (nonatomic, strong) NSString *msgAccountId;

@property (nonatomic, strong) NSString *sendAccountName;
@property (nonatomic, strong) NSString *sendAccountId;
@property (nonatomic, strong) NSString *receiverName;
@property (nonatomic, strong) NSString *receiverAccountId;
@end

NS_ASSUME_NONNULL_END
