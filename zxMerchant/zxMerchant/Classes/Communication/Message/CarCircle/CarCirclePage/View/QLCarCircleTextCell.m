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
        self.timeLBBottom.constant = 0;
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

- (IBAction)likeButtonTouched:(id)sender {
    WEAKSELF
    //只能添加
    [QLNetworkingManager postWithUrl:FirendPath params:@{
        Operation_type:@"add",
        @"account_id":[QLUserInfoModel getLocalInfo].account.account_id,
        @"to_account_id":EncodeStringFromDic([self.dataDic objectForKey:@"account"], @"account_id")
    } success:^(id response) {
        [MBProgressHUD showSuccess:@"关注成功"];
        weakSelf.likeBtn.hidden = YES;
        NSMutableDictionary *dic = [weakSelf.dataDic mutableCopy];
        NSMutableDictionary *business_carDic = [[dic objectForKey:@"business_car"] mutableCopy];
        [business_carDic setValue:@"1" forKey:@"concern"];
        [dic setValue:business_carDic forKey:@"business_car"];
        weakSelf.dataDic = dic;
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}

- (void)upDateWithDic:(NSDictionary *)dic{
    self.dataDic = dic;
    // 头像
    if ([dic objectForKey:@"account"]) {
        if ([[dic objectForKey:@"account"] objectForKey:@"head_pic"]) {
            NSString *urlStr = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"account"] objectForKey:@"head_pic"]];
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
        id flag =  [[dic objectForKey:@"account"] objectForKey:@"flag"];
        if (flag) {
            self.vipBtn.hidden = [flag integerValue] == 1?YES:NO;
        }
        self.timeLB.text = resultString;
       
    }
    id guide_price = [dic objectForKey:@"account"];
    if (guide_price) {
        
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
    
    if ([self.dataDic objectForKey:@"business_car"] && ([EncodeStringFromDic([self.dataDic objectForKey:@"business_car"], @"concern") isEqualToString:@"1"])) {
        self.likeBtn.hidden = YES;
    } else {
        self.likeBtn.hidden = NO;
    }
}

@end
