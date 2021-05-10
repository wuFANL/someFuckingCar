//
//  QLRidersDynamicTextCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/3.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLRidersDynamicTextCell.h"
#import "QLRidersDynamicListModel.h"
@implementation QLRidersDynamicTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(id)model {
    _model = model;
    if ([model isKindOfClass:[QLRidersDynamicListModel class]]) {
        QLRidersDynamicListModel *rdlModel = model;
        NSDate *date = [rdlModel.create_time dateFromString:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *monthStr = [NSString stringWithFormat:@"%02ld月",date.month];
        NSString *dayStr = [NSString stringWithFormat:@"%02ld",date.day];
        NSString *timeStr = [NSString stringWithFormat:@"%@ %@",dayStr,monthStr];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:timeStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 18]} range:[timeStr rangeOfString:dayStr]];
        [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 12]} range:[timeStr rangeOfString:monthStr]];
        self.timeLB.attributedText = string;
        
        self.contentLB.text = rdlModel.dynamic_content;
        
        NSInteger row = [rdlModel.dynamic_content rowsOfStringWithFont:self.contentLB.font withWidth:self.contentLB.width];
        self.showAllBtn = row <= 5?NO:YES;
    }
}
- (void)setShowAllBtn:(BOOL)showAllBtn {
    _showAllBtn = showAllBtn;
    self.allBtn.hidden = !showAllBtn;
    self.allBtnHeight.constant = showAllBtn?25:0;
}
- (IBAction)showBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.contentLB.numberOfLines = sender.selected==YES?5:0;
    [((UITableView *)self.superview ) reloadData];
}

@end
