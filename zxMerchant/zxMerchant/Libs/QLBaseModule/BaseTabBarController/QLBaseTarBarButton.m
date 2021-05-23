//
//  QLBaseTarBarButton.m
//  Template
//
//  Created by 乔磊 on 2017/5/29.
//  Copyright © 2017年 QL. All rights reserved.
//

#import "QLBaseTarBarButton.h"
#import "QLBadgeButton.h"
#import "UIColor+QLUtil.h"
// 图标的比例
#define TabBarButtonImageRatio 0.6
// 按钮的默认文字颜色
#define  QLTabBarButtonTitleColor @"c1c1c1"
// 按钮的选中文字颜色
#define  QLTabBarButtonTitleSelectedColor @"61676e"

@interface QLBaseTarBarButton()

@end
@implementation QLBaseTarBarButton
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self addSubViews];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubViews];
    }
    return self;
}
- (void)addSubViews {
    //只需要设置一次的放置在这里
    self.imageView.contentMode = UIViewContentModeBottom;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self setTitleColor:[UIColor colorWithHexString:QLTabBarButtonTitleColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:QLTabBarButtonTitleSelectedColor] forState:UIControlStateSelected];
    //角标
    _badgeBtn = [[QLBadgeButton alloc]init];
    _badgeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_badgeBtn];
    [self.badgeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(10);
        make.top.equalTo(self.imageView).offset(8);
    }];
}

- (void)setItemColor:(UIColor *)itemColor {
    _itemColor = itemColor;
    [self setTitleColor:_itemColor?_itemColor:[UIColor colorWithHexString:QLTabBarButtonTitleColor] forState:UIControlStateNormal];
}
- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    _itemSelectedColor = itemSelectedColor;
    [self setTitleColor:_itemSelectedColor?_itemSelectedColor:[UIColor colorWithHexString:QLTabBarButtonTitleSelectedColor] forState:UIControlStateSelected];
}
- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    self.badgeBtn.badgeValue = badgeValue;
    
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height*(self.currentTitle.length==0?1:TabBarButtonImageRatio);
    return CGRectMake(0, 0, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height*(self.currentTitle.length==0?1:TabBarButtonImageRatio);
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0,titleY, titleW, titleH);
}

- (void)setTabBarItem:(UITabBarItem *)tabBarItem
{
    // KVO 监听属性改变
    [tabBarItem addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"title" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"image" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    _tabBarItem = tabBarItem;
    //初始化设置
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}
/**
 *  监听到某个对象的属性改变了,就会调用
 *
 *  @param keyPath 属性名
 *  @param object  哪个对象的属性被改变
 *  @param change  属性发生的改变
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 设置文字
    [self setTitle:self.tabBarItem.title forState:UIControlStateSelected];
    [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
    
    // 设置图片
    [self setImage:self.tabBarItem.image forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.selectedImage forState:UIControlStateSelected];
    
    //设置角标
    NSString *badgeValue = self.tabBarItem.badgeValue;
    if(self.tabBarItem.badgeValue.integerValue > 99) {
        badgeValue = @"99+";
    }
    self.badgeValue = badgeValue;
    //设置角标frame
    CGFloat badgeH = self.badgeBtn.currentBackgroundImage.size.height;
    CGFloat badgeW = self.badgeBtn.currentBackgroundImage.size.width;
    if (self.badgeValue.integerValue > 0&&self.badgeBtn.showNum) {
        // 文字的尺寸
        CGFloat width = [self.badgeValue widthWithFont:self.badgeBtn.titleLabel.font] + 10;
        badgeW = (width < 20) ? 20 : width;
        badgeH = badgeW;
    }
    [self.badgeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(badgeW);
        make.height.mas_equalTo(badgeH);
    }];
    
}
- (void)dealloc {
    
    [_tabBarItem removeObserver:self forKeyPath:@"badgeValue"];
    [_tabBarItem removeObserver:self forKeyPath:@"title"];
    [_tabBarItem removeObserver:self forKeyPath:@"image"];
    [_tabBarItem removeObserver:self forKeyPath:@"selectedImage"];
}
//重写该方法可以去除长按按钮时出现的高亮效果
- (void)setHighlighted:(BOOL)highlighted
{
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
