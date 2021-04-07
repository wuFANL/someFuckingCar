//
//  QLSystemMessageCell.h
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/6/7.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLMsgGroupModel.h"
#import "QLMsgModel.h"

@interface QLSystemMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet UILabel *badgeLB;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, assign) NSInteger badgeValue;
@property (nonatomic, strong) id model;
@end
