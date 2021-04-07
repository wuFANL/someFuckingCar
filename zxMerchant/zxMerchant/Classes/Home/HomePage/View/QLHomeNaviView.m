//
//  QLHomeNaviView.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/10/27.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLHomeNaviView.h"
@interface QLHomeNaviView()<QLBaseSearchBarDelegate>

@end
@implementation QLHomeNaviView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = ClearColor;
        //增加按钮
        [self addHeadBtn];
        
    }
    return self;
}
#pragma mark -按钮设置
- (void)addHeadBtn {
    QLBaseTarBarButton *btn = [QLBaseTarBarButton new];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"addFC"] forState:UIControlStateNormal];
    [btn setTitle:@"发车" forState:UIControlStateNormal];
    [btn layoutButtonWithEdgeInsetsStyle:QLButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:btn];
    self.rightBtn = btn;
    //搜索框
    QLBaseSearchBar *searchBar = [QLBaseSearchBar new];
    searchBar.textField.enabled = NO;
    searchBar.placeholder = @"搜索";
    searchBar.placeholderColor = WhiteColor;
    [searchBar setBjColor:[UIColor groupTableViewBackgroundColor]];
    searchBar.isRound = YES;
    searchBar.noEditClick = YES;
    [searchBar setImage:[UIImage imageNamed:@"homeSearchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    searchBar.extenDelegate = self;
    [self addSubview:searchBar];
    self.searchBar = searchBar;
    
    //布局
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.width.height.mas_equalTo(35);
    }];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightBtn);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.rightBtn.mas_left).offset(-15);
        make.height.mas_equalTo(35);
    }];
   
    
}
//搜索框点击
- (void)noEditClick {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(searchBarClick)]) {
        [self.delegate searchBarClick];
    }
    
}
//按钮点击事件
- (void)rightBtnClick {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(msgBtnClick)]) {
        [self.delegate msgBtnClick];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
