//
//  QLSubmitTextCell.h
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/1/16.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLSubmitTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet QLBaseTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeight;
@property (weak, nonatomic) IBOutlet UILabel *unitLB;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
/**
 *设置文字
 */
@property (nonatomic, strong) NSString *content;
/**
 *是否显示分割线
 */
@property (nonatomic, assign) BOOL showLine;

@end

NS_ASSUME_NONNULL_END
