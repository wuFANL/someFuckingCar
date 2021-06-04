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
#import "QLToolsManager.h"
@interface QLChatMsgCell()<QLAttributeTapActionDelegate>
@property (nonatomic, strong) UIView *msgView;
@property (nonatomic, strong) QLChatMsgBContentView *chatContentView;
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

            if([[self.sourceDic objectForKey:@"m_type"] isEqualToString:@"1"]) {
                //纯文本
                contentView.titleLB.text = [self.sourceDic objectForKey:@"content"];
                contentView.titleLB.delegate = self;
                self.msgView = contentView;
            }
            else if ([[self.sourceDic objectForKey:@"m_type"] isEqualToString:@"3"])
            {
                //电话
                NSString *clickAContent = [NSString stringWithFormat:@"%@[回拨]",[self.sourceDic objectForKey:@"contact_mobile"]];
                NSString *content = [NSString stringWithFormat:@"%@ %@",[self.sourceDic objectForKey:@"content"],clickAContent];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName: [UIColor darkTextColor]}];
                [attStr addAttribute:NSLinkAttributeName value:@"detail://" range:[content rangeOfString:clickAContent]];
                [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#006699"]} range:[content rangeOfString:clickAContent]];
                contentView.titleLB.attributedText = attStr;
                contentView.titleLB.delegate = self;
                contentView.titleLB.tag = 1990;
                self.msgView = contentView;
            }
            else
            {
                //车详情
                NSString *clickAContent = @"[查看详情]";
                NSString *content = [NSString stringWithFormat:@"%@ %@",[self.sourceDic objectForKey:@"content"],clickAContent];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName: [UIColor darkTextColor]}];
                [attStr addAttribute:NSLinkAttributeName value:@"detail://" range:[content rangeOfString:clickAContent]];
                [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#006699"]} range:[content rangeOfString:clickAContent]];
                contentView.titleLB.attributedText = attStr;
                contentView.titleLB.delegate = self;
                contentView.titleLB.tag = 1991;
                self.msgView = contentView;
            }
        } else if (self.msgType == ImgMsg) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleToFill;
            [imgView sd_setImageWithURL:[NSURL URLWithString:[self.sourceDic objectForKey:@"file_url"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    if (cacheType == SDImageCacheTypeDisk) {
                        [((UITableView *)self.superview) reloadData];
                    }
                }
            }];
            self.msgView = imgView;
        } else if (self.msgType == AskMsg) {
            self.chatContentView = [QLChatMsgBContentView new];
            WEAKSELF;
            [self.chatContentView setTapBlock:^(NSInteger tag) {
                if(weakSelf.aOrcBlock)
                {
                    weakSelf.aOrcBlock(tag,[[weakSelf.sourceDic objectForKey:@"msg_id"] stringValue]);
                }
            }];
            self.chatContentView.contentLB.text = [self.sourceDic objectForKey:@"content"];
            self.chatContentView.priceLB.text = [[QLToolsManager share] unitConversion:[[self.sourceDic objectForKey:@"price"] floatValue]];
            self.msgView = self.chatContentView;
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
    if ([string containsString:@"detail://"] && label.tag == 1990) {
        NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSString *numberPhone = label.text;
        //获取字符串中的数字

        numberPhone = [[numberPhone componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
        //电话
        [[QLToolsManager share] contactCustomerService:numberPhone];

    }
    else if ([string containsString:@"detail://"] && label.tag == 1991)
    {
        //车文本介绍
        if(self.tapCarBlock)
        {
            self.tapCarBlock();
        }
        
    }
}

//展示两个按钮的view
-(void)showMsgBtnWithDic:(NSDictionary *)dic
{
    NSString *statusStr = [[dic objectForKey:@"status"] stringValue];
    if([[QLUserInfoModel getLocalInfo].account.account_id isEqualToString:[dic objectForKey:@"from_account_id"]] && self.msgType == AskMsg)
    {
        //我发别人
        if([statusStr isEqualToString:@"0"])
        {
            //等待对方确认
            self.chatContentView.agreeBtn.hidden  = YES;
            self.chatContentView.cancelBtn.hidden = YES;
            self.chatContentView.statusLab.hidden = NO;
            self.chatContentView.statusLab.text = @"等待对方确认";
        }
        else if ([statusStr isEqualToString:@"1"])
        {
            //同意
            self.chatContentView.agreeBtn.hidden  = YES;
            self.chatContentView.cancelBtn.hidden = YES;
            self.chatContentView.statusLab.hidden = NO;
            self.chatContentView.statusLab.text = @"对方已同意";
        }
        else
        {
            //不同意
            self.chatContentView.agreeBtn.hidden  = YES;
            self.chatContentView.cancelBtn.hidden = YES;
            self.chatContentView.statusLab.hidden = NO;
            self.chatContentView.statusLab.text = @"对方已拒绝";
        }
    }
    else
    {
        //别人发给我
        if([statusStr isEqualToString:@"0"])
        {
            //展示双按钮
            self.chatContentView.agreeBtn.hidden  = NO;
            self.chatContentView.cancelBtn.hidden = NO;
            self.chatContentView.statusLab.hidden = YES;
        }
        else if ([statusStr isEqualToString:@"1"])
        {
            //同意
            self.chatContentView.agreeBtn.hidden  = YES;
            self.chatContentView.cancelBtn.hidden = YES;
            self.chatContentView.statusLab.hidden = NO;
            self.chatContentView.statusLab.text = @"已同意";
        }
        else
        {
            //不同意
            self.chatContentView.agreeBtn.hidden  = YES;
            self.chatContentView.cancelBtn.hidden = YES;
            self.chatContentView.statusLab.hidden = NO;
            self.chatContentView.statusLab.text = @"已拒绝";
        }

    }
}
@end
