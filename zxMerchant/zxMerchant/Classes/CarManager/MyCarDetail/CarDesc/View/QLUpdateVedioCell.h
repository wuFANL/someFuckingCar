//
//  QLUpdateVedioCell.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/16.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLUpdateVedioCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIControl *uploadControl;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImgView;
@property (weak, nonatomic) IBOutlet QLBaseButton *deleteBtn;

@end

NS_ASSUME_NONNULL_END
