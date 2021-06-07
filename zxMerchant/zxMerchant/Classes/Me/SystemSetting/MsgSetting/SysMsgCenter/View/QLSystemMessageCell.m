//
//  QLSystemMessageCell.m
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/6/7.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLSystemMessageCell.h"

@implementation QLSystemMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView roundRectCornerRadius:6 borderWidth:1 borderColor:ClearColor];
    [self.badgeLB roundRectCornerRadius:18*0.5 borderWidth:1 borderColor:ClearColor];
    self.badgeValue = 0;
}
#pragma mark - setter
- (void)setBadgeValue:(NSInteger)badgeValue {
    _badgeValue = badgeValue;
    if (badgeValue <= 0) {
        self.badgeLB.text = @"";
        self.badgeLB.hidden = YES;
    } else {
        self.badgeLB.text = [NSString stringWithFormat:@"%ld",(long)badgeValue];
        self.badgeLB.hidden = NO;
    }
}
- (void)setModel:(id)model {
    _model = model;
    if ([model isKindOfClass:[QLMsgGroupModel class]]) {
        QLMsgGroupModel *mgModel = model;
        self.titleLB.text = mgModel.title;
        self.detailLB.text = mgModel.current_content.length==0?@"暂无最新消息":mgModel.current_content;
        self.timeLB.text = mgModel.curr_time;
        self.badgeValue = mgModel.msg_count.integerValue;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:mgModel.cover_image] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    } else if ([model isKindOfClass:[QLMsgModel class]]) {
        QLMsgModel *msgModel = model;
        self.titleLB.text = msgModel.title;
        self.detailLB.text = msgModel.content;
        self.timeLB.text = msgModel.create_time;
        NSInteger type = msgModel.jump_type.integerValue;
        NSString *imgName = @"";
        if (type == 1011||type == 1012) {
            //库容通过\库容失败
            imgName = @"msg01";
        } else if (type == 1013||type == 1014) {
            //库容还清\库容结算失败
            imgName = @"msg02";
        } else if (type == 1015) {
            //库容到期提醒
            imgName = @"msg03";
        } else if (type == 1021||type == 1022) {
            //拍卖申请\拍卖审核失败
            imgName = @"msg04";
        } else if (type == 1031) {
            //实名查询成功
            imgName = @"msg06";
        } else if (type == 1041) {
            //竞拍车辆出售
            imgName = @"msg05";
        } else {
            imgName = @"defaultHead";
        }
        self.imgView.image = [UIImage imageNamed:imgName];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
