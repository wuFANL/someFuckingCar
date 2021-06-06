//
//  QLBrowseDetailHeadView.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/31.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLBrowseDetailHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet QLBaseButton *detailBtn;

@end

NS_ASSUME_NONNULL_END
