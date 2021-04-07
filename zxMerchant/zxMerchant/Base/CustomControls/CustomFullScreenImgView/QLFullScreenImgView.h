//
//  QLFullScreenImgView.h
//  BORDRIN
//
//  Created by 乔磊 on 2018/10/9.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLFullScreenImgView : QLBaseView
/**
 *图片地址
 */
@property (nonatomic, strong) NSString *imgUrl;
/**
 *图片
 */
@property (nonatomic, strong) UIImage *img;
- (void)show;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
