//
//  QLVipPriceItem.h
//  zxMerchant
//
//  Created by lei qiao on 2021/1/19.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLVipPriceItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLB;

@end

NS_ASSUME_NONNULL_END
