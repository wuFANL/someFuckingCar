//
//  QLChatFloatView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/18.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLChatFloatView : UIView
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet QLBaseTarBarButton *headBtn;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@end

NS_ASSUME_NONNULL_END
