//
//  QLTableImgCell.h
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/4/26.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLTableImgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@end
