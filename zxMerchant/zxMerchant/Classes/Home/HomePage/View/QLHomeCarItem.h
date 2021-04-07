//
//  QLHomeCarItem.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/3.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLHomeCarItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carImgView;
@property (weak, nonatomic) IBOutlet UIImageView *accImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *yearLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;

@end

NS_ASSUME_NONNULL_END
