//
//  QLJoinStoreCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectedIndexBlock)(void);

@interface QLJoinStoreCell : UITableViewCell
@property (nonatomic, copy) SelectedIndexBlock selectedBlock;
@property (nonatomic, strong) IBOutlet UILabel *carName;
@property (nonatomic, strong) IBOutlet UILabel *carAddress;
@property (nonatomic, strong) IBOutlet UIImageView *carImageV;

@end

NS_ASSUME_NONNULL_END
