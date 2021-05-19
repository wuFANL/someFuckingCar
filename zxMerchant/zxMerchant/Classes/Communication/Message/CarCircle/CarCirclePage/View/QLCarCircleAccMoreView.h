//
//  QLCarCircleAccMoreView.h
//  zxMerchant
//
//  Created by lei qiao on 2021/5/19.
//  Copyright © 2021 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLCarCircleAccMoreView : UIView

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreCloseBtn;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
