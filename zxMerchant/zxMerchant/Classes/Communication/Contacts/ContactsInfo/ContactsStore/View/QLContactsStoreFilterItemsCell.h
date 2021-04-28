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

typedef void (^CarSelectedBlock) (NSString *carID);
typedef void (^CarPriceSelectedBlock) (NSString *price);
typedef void (^AllSelectedBlock) (void);

@interface QLContactsStoreFilterItemsCell : UITableViewCell
@property (nonatomic, copy) CarSelectedBlock carBlock;
@property (nonatomic, copy) CarPriceSelectedBlock carPriceBlock;
@property (nonatomic, copy) AllSelectedBlock allBlock;

@property (nonatomic, strong) QLBaseCollectionView *carIconCollectionView;
@property (nonatomic, strong) QLBaseCollectionView *priceCollectionView;
@property (weak, nonatomic) IBOutlet UIControl *accControl;

@end

NS_ASSUME_NONNULL_END
