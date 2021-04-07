//
//  QLCityTableViewCell.h
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/5/31.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLCityListModel.h"
typedef void (^selectedIndexBlock)(NSInteger section,NSInteger row);
@interface QLCityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (nonatomic, strong) QLCityListModel *model;
@property (nonatomic, strong) selectedIndexBlock selectedBlock;
@end
