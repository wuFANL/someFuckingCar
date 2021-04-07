//
//  QLMyCarDetailHeadView.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/14.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QLMyCarDetailHeadView;
@protocol QLMyCarDetailHeadViewDelegate <NSObject>
@optional
- (void)selectIndex:(NSInteger)index Data:(NSMutableArray *)dataAr;
@end

@interface QLMyCarDetailHeadView : UIView

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numLB;
@property (weak, nonatomic) IBOutlet UILabel *progressLB;
/**
 *图片数据
 */
@property (nonatomic, strong) NSArray *bannerArr;
/**
 *代理
 */
@property (nonatomic, weak) id<QLMyCarDetailHeadViewDelegate> deleage;
@end

NS_ASSUME_NONNULL_END
