//
//  QLVehicleReportCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/11.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLVehicleReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet QLBaseButton *accBtn;

@end

NS_ASSUME_NONNULL_END
