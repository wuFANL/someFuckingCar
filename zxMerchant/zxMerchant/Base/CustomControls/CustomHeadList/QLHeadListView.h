//
//  QLHeadListView.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/18.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,StartDirection) {
    DirectionLeft = 0,//从左开始
    DirectionRight = 1,//从右开始
};
@class QLHeadListView;
@protocol QLHeadListViewDelegate <NSObject>
@optional
- (void)setItemIndex:(NSInteger)index Obj:(UIButton *)itemBtn;
- (void)clickItemIndex:(NSInteger)index Obj:(UIButton *)itemBtn;
@end
@interface QLHeadListView : UIScrollView
/**
 *头像数据
 */
@property (nonatomic, strong) NSArray *headsArr;
/**
 *排序方向
 */
@property (nonatomic, assign) StartDirection direction;
/**
 *代理
 */
@property (nonatomic, weak) id<QLHeadListViewDelegate> headDelegate;
@end

NS_ASSUME_NONNULL_END
