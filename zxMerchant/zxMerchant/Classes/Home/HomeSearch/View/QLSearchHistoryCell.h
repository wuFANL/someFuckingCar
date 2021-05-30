//
//  QLSearchHistoryCell.h
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/5/11.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectedResultBlock)(id result);
@interface QLSearchHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
/**
 *数据
 */
@property (nonatomic, strong) NSArray *itemArr;
/**
 *item点击回调
 */
@property (nonatomic, strong) selectedResultBlock result;
@end
