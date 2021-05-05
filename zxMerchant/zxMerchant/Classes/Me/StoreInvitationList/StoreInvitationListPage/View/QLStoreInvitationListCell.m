//
//  QLStoreInvitationListCell.m
//  zxMerchant
//
//  Created by lei qiao on 2021/1/9.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLStoreInvitationListCell.h"

@implementation QLStoreInvitationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(NSDictionary *)data{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:EncodeStringFromDic(data, @"head_pic")]];
    self.nameLB.text = EncodeStringFromDic(data, @"personnel_nickname");
    [self.mobileBtn setTitle:EncodeStringFromDic(data, @"mobile") forState:UIControlStateNormal];
    
//    0=申请加入 1=在职 2=离职 99=拒绝申请
    NSString* stateStr = EncodeStringFromDic(data, @"state");
    if ([stateStr isEqualToString:@"0"]) {
        [self.statusBtn setTitle:@"待审核" forState:UIControlStateNormal];
    } else if ([stateStr isEqualToString:@"1"]) {
        [self.statusBtn setTitle:@"在职" forState:UIControlStateNormal];
    } else if ([stateStr isEqualToString:@"2"]) {
        [self.statusBtn setTitle:@"离职" forState:UIControlStateNormal];
    } else {
        [self.statusBtn setTitle:@"拒绝申请" forState:UIControlStateNormal];
    }
}

@end
