//
//  QLChatMsgCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/9.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLChatMsgCell.h"
#import "QLChatMsgAContentView.h"
#import "QLChatMsgBContentView.h"

@interface QLChatMsgCell()<QLAttributeTapActionDelegate>
@property (nonatomic, strong) UIView *msgView;

@end
@implementation QLChatMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
#pragma mark - setter
- (void)setMsgReceiver:(MsgReceiver)msgReceiver {
    _msgReceiver = msgReceiver;
    
    [self addMsgView];
}
- (void)setMsgType:(MsgType)msgType {
    _msgType = msgType;
    
    [self addMsgView];
}
#pragma mark - action
- (void)addMsgView {
    //移除之前图层
    [self.msgView removeFromSuperview];
    self.msgView = nil;
    //新增
    if (self.msgReceiver != UnknowReceiver&&self.msgType != UnknowMsg) {
        if (self.msgType == TextMsg) {
            QLChatMsgAContentView *contentView = [QLChatMsgAContentView new];
            UIFont *font = [UIFont fontWithName:@"PingFang SC" size:13];
            NSString *content = @"【21.3万】这里传车辆品牌、车系、车型、表显里程、过户次数、排量、变速箱车身颜色[查看详情]";
            NSString *clickAContent = @"[查看详情]";
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName: [UIColor darkTextColor]}];
            [attStr addAttribute:NSLinkAttributeName value:@"detail://" range:[content rangeOfString:clickAContent]];
            [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#006699"]} range:[content rangeOfString:clickAContent]];
            contentView.titleLB.attributedText = attStr;
            contentView.titleLB.delegate = self;
            self.msgView = contentView;
        } else if (self.msgType == ImgMsg) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [UIImage imageNamed:@"icon"];
            self.msgView = imgView;
        } else if (self.msgType == AskMsg) {
            QLChatMsgBContentView *contentView = [QLChatMsgBContentView new];
            self.msgView = contentView;
        }
        //添加内容
        if (self.msgReceiver == MyMsg) {
            self.aHeadControl.hidden = YES;
            self.aMsgBjView.hidden = YES;
            self.bHeadControl.hidden = NO;
            self.bMsgBjView.hidden = NO;
            
            [self.bMsgBjView addSubview:self.msgView];
        } else {
            self.bHeadControl.hidden = YES;
            self.bMsgBjView.hidden = YES;
            self.aHeadControl.hidden = NO;
            self.aMsgBjView.hidden = NO;
            
            [self.aMsgBjView addSubview:self.msgView];
        }
        
        [self.msgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(12, 15, 12, 15));
        }];
    }
}
//文本点击
- (void)tapAttributeInLabel:(UILabel *)label string:(NSString *)string range:(NSRange)range {
    //查看详情
    if ([string containsString:@"detail://"]) {
        
    }
}
@end
