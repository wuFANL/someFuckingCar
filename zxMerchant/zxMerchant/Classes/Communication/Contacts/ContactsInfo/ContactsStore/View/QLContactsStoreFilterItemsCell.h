//
//  QLContactsStoreFilterItemsCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLImgTextItem.h"
#import "QLConditionsItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLContactsStoreFilterItemsCell : UITableViewCell
@property (nonatomic, strong) QLBaseCollectionView *carIconCollectionView;
@property (nonatomic, strong) QLBaseCollectionView *priceCollectionView;
@property (weak, nonatomic) IBOutlet UIControl *accControl;

@end

NS_ASSUME_NONNULL_END
