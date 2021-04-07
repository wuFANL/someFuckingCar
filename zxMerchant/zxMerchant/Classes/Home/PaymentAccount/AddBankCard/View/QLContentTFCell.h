//
//  QLContentTFCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/10/21.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLContentTFCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UIImageView *accImgView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewRight;

@end

NS_ASSUME_NONNULL_END
