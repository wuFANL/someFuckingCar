//
//  QLContactsDescCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/10.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLContactsDescCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nikenameLB;
@property (weak, nonatomic) IBOutlet UILabel *numLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@end

NS_ASSUME_NONNULL_END
