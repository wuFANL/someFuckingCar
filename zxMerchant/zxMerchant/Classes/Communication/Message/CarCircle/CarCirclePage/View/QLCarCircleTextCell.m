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
    self.vipBtn.hidden = YES;
    self.headBtn.layer.cornerRadius = 8;
    self.headBtn.clipsToBounds = YES;
}

- (void)setModel:(QLRidersDynamicListModel *)model {
    _model = model;
    if (model) {
        QLRidersDynamicListModel *rdlModel = model;
        
        [self.headBtn sd_setImageWithURL:[NSURL URLWithString:model.account_head_pic] forState:UIControlStateNormal];
        [self.nikenameBtn setTitle:model.account_nickname forState:UIControlStateNormal];
        self.vipBtn.hidden = model.flag.integerValue ==1?YES:NO;
        self.timeLB.text = @"";
        self.textLB.text = rdlModel.dynamic_content;
        NSInteger row = [rdlModel.dynamic_content rowsOfStringWithFont:self.textLB.font withWidth:self.textLB.width];
        self.showAllBtn = row <= 5?NO:YES;
    }
}
- (void)setShowAllBtn:(BOOL)showAllBtn {
    _showAllBtn = showAllBtn;
    self.openBtn.hidden = !showAllBtn;
    self.openBtnHight.constant = showAllBtn?25:0;
}
- (IBAction)showAllBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.textLB.numberOfLines = sender.selected==YES?5:0;
    [((UITableView *)self.superview ) reloadData];
    
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
