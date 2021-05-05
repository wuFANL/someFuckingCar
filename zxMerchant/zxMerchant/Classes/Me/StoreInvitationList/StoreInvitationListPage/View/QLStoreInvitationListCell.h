//
//  QLStoreInvitationListCell.h
//  zxMerchant
//
//  Created by lei qiao on 2021/1/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLStoreInvitationListCell : UITableViewCell
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLB;

// 电话号码
@property (weak, nonatomic) IBOutlet QLBaseButton *mobileBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *iconBtn;
// 状态
@property (weak, nonatomic) IBOutlet QLBaseButton *statusBtn;

- (void)updateWithData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
