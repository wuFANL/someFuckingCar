//
//  QLSubmitTextCell.m
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/1/16.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLSubmitTextCell.h"
@interface QLSubmitTextCell()

@end
@implementation QLSubmitTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.showCountLimit = NO;
    self.textView.showsVerticalScrollIndicator = NO;

}
//设置输入框内容
- (void)setContent:(NSString *)content {
    self.textView.text = content;
    self.textView.placeholderLB.hidden = YES;
}
//设置是否隐藏分割线
- (void)setShowLine:(BOOL)showLine {
    self.lineView.hidden = showLine?NO:YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
