//
//  QLBaseButton.h
//  Integral
//
//  Created by 乔磊 on 2019/4/3.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLBaseButton : UIButton
/**
 *是否去除高亮
 */
@property (nonatomic, assign) IBInspectable BOOL light;
@end

NS_ASSUME_NONNULL_END
