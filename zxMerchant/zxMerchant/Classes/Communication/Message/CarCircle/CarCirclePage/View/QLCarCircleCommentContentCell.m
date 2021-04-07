//
//  QLCarCircleCommentContentCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/29.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarCircleCommentContentCell.h"

@implementation QLCarCircleCommentContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString *senderName = @"昵称A";
    NSString *receiverName = @"昵称B";
    NSString *content = @"传回复内容多行显示,回复内容录入多少显示多少";
    NSString *completeContent = [NSString stringWithFormat:@"%@%@%@%@",senderName,receiverName.length==0?@":":@"回复",receiverName,content];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:completeContent attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor darkTextColor]}];
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#006699"]} range:[completeContent rangeOfString:senderName]];
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#006699"]} range:[completeContent rangeOfString:receiverName]];
    self.contentLB.attributedText = attr;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
