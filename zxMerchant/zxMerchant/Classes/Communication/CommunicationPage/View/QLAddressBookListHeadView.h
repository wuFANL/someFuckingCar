//
//  QLAddressBookListHeadView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/4.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLChooseHeadView.h"

NS_ASSUME_NONNULL_BEGIN
@class QLAddressBookListHeadView;
@protocol QLAddressBookListHeadViewDelegate <NSObject>
@optional
/**
 *类型切换下标
 */
- (void)chooseSelectIndex:(NSInteger)index;
/**
 *搜索栏点击
 */
- (void)searchBarClick;
/**
 *分区模块点击
 */
- (void)sectionClick;
@end

@interface QLAddressBookListHeadView : UIView
@property (weak, nonatomic) IBOutlet QLChooseHeadView *chooseView;
@property (weak, nonatomic) IBOutlet QLBaseSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIControl *sectionControl;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sectionImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet QLBaseTarBarButton *accBtn;
@property (weak, nonatomic) IBOutlet UIImageView *accImgView;
/**
 *代理
 */
@property (nonatomic, weak) id<QLAddressBookListHeadViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
