//
//  QLEditPermissionCell.m
//  zxMerchant
//
//  Created by lei qiao on 2021/2/23.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLEditPermissionCell.h"

@implementation QLEditPermissionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectBtn.selected = selected;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    self.titleLB.text = [dataDic objectForKey:@"role_name"];
    NSArray *permission_list = [dataDic objectForKey:@"permission_list"];
    NSString *contentStr = @"";
    for (NSUInteger i = 0; i<permission_list.count; i++) {
        contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@  ",[permission_list[i] objectForKey:@"function_name"]]];
    }
    self.accLB.text = contentStr;
}

@end
