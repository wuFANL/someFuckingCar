//
//  QLCarCircleTextCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/26.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLCarCircleTextCell.h"

@implementation QLCarCircleTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)upDateWithDic:(NSDictionary *)dic{
    // 头像
    if ([dic objectForKey:@"account"]) {
        if ([[dic objectForKey:@"account"] objectForKey:@"head_pic"]) {
            NSString *urlStr = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"account"] objectForKey:@"head_pic"]];
//            [self.headBtn.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
            [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal];
        }
    }
    
    // 昵称
    if ([dic objectForKey:@"account"]) {
        if ([[dic objectForKey:@"account"] objectForKey:@"nickname"]) {
            [self.nikenameBtn setTitle:[NSString stringWithFormat:@"%@",[[dic objectForKey:@"account"] objectForKey:@"nickname"]] forState:UIControlStateNormal];
        }
    }
    
    // 时间印记 和 地点
    if ([dic objectForKey:@"account"]) {
        NSString * resultString = @"";
        if ([[dic objectForKey:@"account"] objectForKey:@"create_time"]) {
            NSString *dateStr = [[dic objectForKey:@"account"] objectForKey:@"create_time"];
            NSString * resultTime = [QLToolsManager compareCurrentTime:[NSString stringWithFormat:@"%@",dateStr]];
            
            resultString = resultTime;
        }
        
        if ([[dic objectForKey:@"account"] objectForKey:@"business_area"]) {
            resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"  %@",[[dic objectForKey:@"account"] objectForKey:@"business_area"]]];
        }
        self.timeLB.text = resultString;
       
    }
    
    // 描述
    if ([dic objectForKey:@"business_car"]) {
        if ([[dic objectForKey:@"business_car"] objectForKey:@"explain"]) {
            self.textLB.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"business_car"] objectForKey:@"explain"]];
        }
    }
    
    
    //    是否有vip 在account对象里flag字段
    //    1=无会员 2=全省会员 3=全国会员
    
    
    //是否关注字段 在business_car 对象里concern字段
    //    已关注=1，未关注=0
    
    if ([dic objectForKey:@"business_car"] && ([[[dic objectForKey:@"business_car"] objectForKey:@"concern"] isEqual:@(1)])) {
        self.likeBtn.hidden = YES;
    } else {
        self.likeBtn.hidden = NO;
    }
}

@end
