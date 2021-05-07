//
//  QLChatListHeadItem.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/5.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLChatListHeadItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet QLBaseButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLB;
-(void)showBadge:(NSString *)num;
@end

NS_ASSUME_NONNULL_END
