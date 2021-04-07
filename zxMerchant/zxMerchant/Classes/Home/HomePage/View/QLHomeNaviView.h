//
//  QLHomeNaviView.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/10/27.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QLHomeNaviView;
@protocol QLHomeNaviViewDelegate <NSObject>
@optional
- (void)searchBarClick;
- (void)msgBtnClick;
@end
@interface QLHomeNaviView : UIView
@property (nonatomic, weak) QLBaseTarBarButton *rightBtn;
@property (nonatomic, weak) QLBaseSearchBar *searchBar;
@property (nonatomic, weak) id<QLHomeNaviViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
