//
//  QLSaveImgManager.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/9/28.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLSaveImgManager : NSObject
/*
 *保存图片
 */
- (void)saveImgs:(NSArray <UIImage *>*)imgsArr complete:(ResultBlock)handler;
/*
 *单例
 */
+ (QLSaveImgManager *)share;
@end

NS_ASSUME_NONNULL_END
