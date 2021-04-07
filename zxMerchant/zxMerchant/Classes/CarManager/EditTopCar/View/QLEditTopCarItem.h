//
//  QLEditTopCarItem.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/7.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLEditTopCarItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@end

NS_ASSUME_NONNULL_END
