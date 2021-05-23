//
//  QLCarCircleCommentContentCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarCircleCommentContentCell.h"
#import "QLRidersDynamicListModel.h"

@implementation QLCarCircleCommentContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setModel:(id)model {
    _model = model;
    if ([model isKindOfClass:[QLRidersDynamicInteractModel class]]) {
        QLRidersDynamicInteractModel *iModel = model;
        
        NSString *senderName = QLNONull(iModel.account_name);
        NSString *receiverName = QLNONull(iModel.to_account_name);
        NSString *content = iModel.content;
        NSString *completeContent = [NSString stringWithFormat:@"%@%@%@%@",senderName,receiverName.length==0?@":":@"回复",receiverName,content];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:completeContent attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor darkTextColor]}];
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#006699"]} range:[completeContent rangeOfString:senderName]];
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#006699"]} range:[completeContent rangeOfString:receiverName]];
        self.contentLB.attributedText = attr;
    }
}

@end
