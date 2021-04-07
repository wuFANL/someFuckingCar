//
//  QLMePageHeadView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLMePageHeadView : UIView
@property (weak, nonatomic) IBOutlet QLBaseButton *headBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *nikenameBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *storeNameBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *numBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *storeInvitationBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *vipStatusBtn;
@property (weak, nonatomic) IBOutlet UIControl *aControl;
@property (weak, nonatomic) IBOutlet UILabel *aNumLB;
@property (weak, nonatomic) IBOutlet UIControl *bControl;
@property (weak, nonatomic) IBOutlet UILabel *bNumLB;
@property (weak, nonatomic) IBOutlet UIControl *cControl;
@property (weak, nonatomic) IBOutlet UILabel *cNumLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UIButton *lookDetailBtn;

@end

NS_ASSUME_NONNULL_END
