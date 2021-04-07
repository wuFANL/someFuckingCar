//
//  QLCarDescTypeCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/16.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCarDescTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *aBtn;
@property (weak, nonatomic) IBOutlet UIButton *bBtn;
- (IBAction)typeBtnClick:(UIButton *)sender;
@property (nonatomic, strong) resultBackBlock handler;
@end

NS_ASSUME_NONNULL_END
