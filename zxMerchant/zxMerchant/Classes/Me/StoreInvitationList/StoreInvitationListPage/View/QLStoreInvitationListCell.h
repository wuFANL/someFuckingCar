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
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet QLBaseButton *mobileBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *iconBtn;
@property (weak, nonatomic) IBOutlet QLBaseButton *statusBtn;

@end

NS_ASSUME_NONNULL_END
