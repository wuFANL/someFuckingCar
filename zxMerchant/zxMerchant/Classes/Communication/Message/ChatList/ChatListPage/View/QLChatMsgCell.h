//
//  QLChatMsgCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/9.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,MsgReceiver) {
    UnknowReceiver = 0,
    MyMsg = 1,
    OtherMsg = 2
};
typedef NS_ENUM(NSInteger,MsgType) {
    UnknowMsg = 0,
    TextMsg = 1,
    ImgMsg = 2,
    AskMsg = 3,
    
};
@interface QLChatMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIControl *aHeadControl;
@property (weak, nonatomic) IBOutlet UIImageView *aHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel *aHeadLB;
@property (weak, nonatomic) IBOutlet UIView *aMsgBjView;
@property (weak, nonatomic) IBOutlet UIControl *bHeadControl;
@property (weak, nonatomic) IBOutlet UIImageView *bHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel *bHeadLB;
@property (weak, nonatomic) IBOutlet UIView *bMsgBjView;

@property (nonatomic, assign) MsgReceiver msgReceiver;
@property (nonatomic, assign) MsgType msgType;
@end

NS_ASSUME_NONNULL_END
