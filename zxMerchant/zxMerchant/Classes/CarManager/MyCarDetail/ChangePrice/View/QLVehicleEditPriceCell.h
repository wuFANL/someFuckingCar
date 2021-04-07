//
//  QLVehicleEditPriceCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/12.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLVehicleEditPriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UIButton *accBtn;
@property (weak, nonatomic) IBOutlet UIView *tfView;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UILabel *unitLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftAccHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftAccBottom;
@property (weak, nonatomic) IBOutlet UILabel *leftAccLB;
@property (weak, nonatomic) IBOutlet UILabel *rightAccLB;

/**
 *是否显示底部accLB
 */
@property (nonatomic, assign) BOOL showAccLB;
@end

NS_ASSUME_NONNULL_END
