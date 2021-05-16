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
// 头像
@property (weak, nonatomic) IBOutlet QLBaseButton *headBtn;
// 昵称
@property (weak, nonatomic) IBOutlet QLBaseButton *nikenameBtn;
// 店铺名称
@property (weak, nonatomic) IBOutlet QLBaseButton *storeNameBtn;
// 编号
@property (weak, nonatomic) IBOutlet QLBaseButton *numBtn;
// 店铺邀请
@property (weak, nonatomic) IBOutlet QLBaseButton *storeInvitationBtn;
// 会员资格
@property (weak, nonatomic) IBOutlet QLBaseButton *vipStatusBtn;

@property (weak, nonatomic) IBOutlet UIControl *aControl;
// 我的浏览
@property (weak, nonatomic) IBOutlet UILabel *aNumLB;

@property (weak, nonatomic) IBOutlet UIControl *bControl;
// 我的帮卖
@property (weak, nonatomic) IBOutlet UILabel *bNumLB;
@property (weak, nonatomic) IBOutlet UIControl *cControl;
// 我的订阅
@property (weak, nonatomic) IBOutlet UILabel *cNumLB;
// 消费贷
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UIButton *lookDetailBtn;
@property (weak, nonatomic) IBOutlet UIView *yjView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yjViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yjViewTop;


- (void)updateData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
