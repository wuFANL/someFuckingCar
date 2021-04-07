//
//  QLBankCardCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/5/15.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLBankCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bankLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *cBtn;

@end

NS_ASSUME_NONNULL_END
