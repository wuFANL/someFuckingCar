//
//  QLIntervalTextCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/22.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLIntervalTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UITextField *aTF;
@property (weak, nonatomic) IBOutlet UILabel *lineLB;
@property (weak, nonatomic) IBOutlet UITextField *bTF;
@property (weak, nonatomic) IBOutlet UILabel *unitLB;

@end

NS_ASSUME_NONNULL_END
