//
//  QLNewFriendCell.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/12.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^BtnTapBlock) (NSInteger tag);
@interface QLNewFriendCell : UITableViewCell
@property (nonatomic, copy) BtnTapBlock btnTBlock;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *mobileLB;
@property (weak, nonatomic) IBOutlet QLBaseButton *collectionBtn;

@end

NS_ASSUME_NONNULL_END
