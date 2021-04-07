//
//  QLBaseTabBar.m
//  Template
//
//  Created by 乔磊 on 2017/5/29.
//  Copyright © 2017年 QL. All rights reserved.
//

#import "QLBaseTabBar.h"

@interface QLBaseTabBar ()

@property(nonatomic, weak) QLBaseTarBarButton *centerBtn;

@property(nonatomic, weak) QLBaseTarBarButton *selectedButton;
@end
@implementation QLBaseTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.centerBtn) {
        self.centerBtn.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    }
    
    CGFloat btnY = 0;
    CGFloat btnW = 0;
    CGFloat btnH = self.frame.size.height;
    //计算最大宽度
    for (QLBaseTarBarButton *tabBarBtn in self.tabbarBtnArray) {
        NSString *title = tabBarBtn.titleLabel.text;
        UIFont *font = tabBarBtn.titleLabel.font;
        CGFloat width = [title widthWithFont:font]+20;
        btnW = btnW>width?btnW:width;
    }
    //计算间隙
    CGFloat space = (self.frame.size.width-(btnW*self.subviews.count))/(self.subviews.count*2);
    //设置frame
    for (int nIndex = 0; nIndex < self.tabbarBtnArray.count; nIndex++) {
        CGFloat btnX = btnW*nIndex+space*(1+2*nIndex);
        QLBaseTarBarButton *tabBarBtn = self.tabbarBtnArray[nIndex];
        if (_showCenterBtn) {
            if (nIndex > 1) {
                btnX += btnW;
            }
        }
        tabBarBtn.itemSelectedColor = _itemSelectedColor;
        tabBarBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        tabBarBtn.tag = nIndex+10;
        
    }
}
- (void)setItemColor:(UIColor *)itemColor {
    _itemColor = itemColor;
    for (QLBaseTarBarButton *item in self.subviews) {
         item.itemColor = _itemColor;
    }
}
- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    _itemSelectedColor = itemSelectedColor;
    for (QLBaseTarBarButton *item in self.subviews) {
        item.itemSelectedColor = _itemSelectedColor;
    }
}
- (void)setShowBadgeText:(BOOL)showBadgeText {
    _showBadgeText = showBadgeText;
    for (QLBaseTarBarButton *btn in self.tabbarBtnArray) {
        btn.badgeBtn.showNum = self.showBadgeText;
    }
    
}
//中间加按钮
- (void)SetupCenterButton{
    QLBaseTarBarButton *centerBtn = [QLBaseTarBarButton new];
    centerBtn.adjustsImageWhenHighlighted = NO;
    [centerBtn addTarget:self action:@selector(ClickCenterButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:centerBtn];
    _centerBtn = centerBtn;
}
- (void)setShowCenterBtn:(BOOL)showCenterBtn {
    _showCenterBtn = showCenterBtn;
    //中间加按钮
    if (_showCenterBtn) {
        if (!_centerBtn) {
            [self SetupCenterButton];
        }
    } else {
        [_centerBtn removeFromSuperview];
    }
    [self layoutIfNeeded];
}
- (void)setCenterBtnImageNmae:(NSString *)centerBtnImageNmae {
    _centerBtnImageNmae = centerBtnImageNmae;
    if (_centerBtn) {
       [_centerBtn setBackgroundImage:[UIImage imageNamed:_centerBtnImageNmae] forState:UIControlStateNormal];
        _centerBtn.bounds = CGRectMake(0, 0, _centerBtn.currentBackgroundImage.size.width, _centerBtn.currentBackgroundImage.size.height);
    }
    [self layoutIfNeeded];
}
- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem {
    QLBaseTarBarButton *tabBarBtn = [[QLBaseTarBarButton alloc] init];
    tabBarBtn.tabBarItem = tabBarItem;
    [tabBarBtn addTarget:self action:@selector(ClickTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tabBarBtn];
    [self.tabbarBtnArray addObject:tabBarBtn];
    if (self.tabbarBtnArray.count == 1) {
        [self ClickTabBarButton:tabBarBtn];
    }
    [self layoutIfNeeded];
}
- (void)ClickTabBarButton:(QLBaseTarBarButton *)tabBarBtn {
    if ([self.tbDelegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.tbDelegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:tabBarBtn.tag];
    }
    [self btnChange:tabBarBtn];
}
- (void)btnChange:(QLBaseTarBarButton *)tabBarBtn  {
    self.selectedButton.selected = NO;
    tabBarBtn.selected = YES;
    self.selectedButton = tabBarBtn;
}
- (void)ClickCenterButton{
    if ([self.tbDelegate respondsToSelector:@selector(tabBarClickCenterButton:)]) {
        [self.tbDelegate tabBarClickCenterButton:self];
    }
}
- (NSMutableArray *)tabbarBtnArray{
    if (!_tabbarBtnArray) {
        _tabbarBtnArray = [NSMutableArray array];
    }
    return  _tabbarBtnArray;
}

@end
