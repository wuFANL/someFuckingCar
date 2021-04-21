//
//  QLJoinStoreCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLJoinStoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet QLBaseButton *applyBtn;

@end

NS_ASSUME_NONNULL_END
