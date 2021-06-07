//
//  QLShareHistoryCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/30.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLShareHistoryCell.h"
@interface QLShareHistoryCell()<QLHeadListViewDelegate>
@property (nonatomic, weak) QLHeadListView *hlView;
@end
@implementation QLShareHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.browseNum = @"0";
    QLHeadListView *hlView = [QLHeadListView new];
    hlView.direction = DirectionRight;
    hlView.headDelegate = self;
    [self.contentView addSubview:hlView];
    [hlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.browseBtn);
        make.right.equalTo(self.browseBtn.mas_left).offset(-10);
        make.left.equalTo(self.timeLB.mas_right).offset(12);
        make.height.mas_equalTo(25);
    }];
    self.hlView = hlView;
}
- (void)setModel:(QLShareHistoryModel *)model {
    _model = model;
    if (model) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.head_pic]];
        self.titleLB.text = model.title;
        self.timeLB.text = model.update_time;
        self.browseNum = model.visit_num;
        //头像列表
        NSArray *titles = model.pic_list;
        self.hlView.headsArr = titles;
        
    }
}
//设置头像列表
- (void)setItemIndex:(NSInteger)index Obj:(UIButton *)itemBtn {
    NSString *url = self.model.pic_list[index];
    [itemBtn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
}
//头像列表点击
- (void)clickItemIndex:(NSInteger)index Obj:(UIButton *)itemBtn {
    
}
//设置浏览人数
- (void)setBrowseNum:(NSString *)browseNum {
    _browseNum = browseNum;
    NSString *title = [NSString stringWithFormat:@"%@人看啦",browseNum];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size: 13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF8340"]}];
    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor darkTextColor]} range:[title rangeOfString:@"人看啦"]];
    [self.browseBtn setAttributedTitle:string forState:UIControlStateNormal];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
