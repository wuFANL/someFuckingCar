//
//  QLAddressBookListHeadView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/4.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLAddressBookListHeadView.h"
@interface QLAddressBookListHeadView()<UISearchBarDelegate,QLChooseHeadViewDelegate,QLBaseSearchBarDelegate>

@end
@implementation QLAddressBookListHeadView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLAddressBookListHeadView viewFromXib];
        //类型切换
        self.chooseView.column = 2;
        self.chooseView.typeArr = @[@"消息",@"通讯"];
        self.chooseView.lineColor = GreenColor;
        self.chooseView.lineWidth = 10;
        self.chooseView.typeDelegate = self;
        //搜索栏
        self.searchBar.noEditClick = YES;
        self.searchBar.extenDelegate = self;
        //分区模块点击
        [self.sectionControl addTarget:self action:@selector(sectionControlClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.accBtn.hidden = YES;
        self.accBtn.badgeValue = @"0";
        [self.accBtn roundRectCornerRadius:6 borderWidth:1 borderColor:ClearColor];

    }
    return self;
}

#pragma mark - action
//搜索框点击
- (void)noEditClick {
    if ([self.delegate respondsToSelector:@selector(searchBarClick)]) {
        [self.delegate searchBarClick];
    }
}
//section模块点击
- (void)sectionControlClick {
    if ([self.delegate respondsToSelector:@selector(sectionClick)]) {
        [self.delegate sectionClick];
    }
}
//头部选择样式设置
- (void)chooseTitleStyle:(UIButton *)chooseBtn Index:(NSInteger)index {
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
}
//头部选择点击
- (void)chooseSelect:(UIButton *)lastBtn CurrentBtn:(UIButton *)currentBtn Index:(NSInteger)index {
    lastBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    currentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    if ([self.delegate respondsToSelector:@selector(chooseSelectIndex:)]) {
        [self.delegate chooseSelectIndex:index];
    }
}

@end
