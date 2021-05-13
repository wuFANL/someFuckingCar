//
//  QLChatMsgBContentView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^TapBtnBlock) (NSInteger tag);
@interface QLChatMsgBContentView : UIView
@property (nonatomic, copy) TapBtnBlock tapBlock;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@end

NS_ASSUME_NONNULL_END
