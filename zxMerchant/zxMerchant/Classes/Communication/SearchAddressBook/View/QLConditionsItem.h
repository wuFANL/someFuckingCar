//
//  QLConditionsItem.h
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/6/11.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLConditionsItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteLeftSpace;
/*
 *是否显示删除按钮
 */
@property (nonatomic, assign) BOOL showDeleteBtn;
@end
