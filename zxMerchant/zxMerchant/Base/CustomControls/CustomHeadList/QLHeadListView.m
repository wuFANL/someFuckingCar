//
//  QLHeadListView.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/18.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLHeadListView.h"

@implementation QLHeadListView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
- (void)layoutSubviews {
    CGFloat itemWidth = self.height;
    CGFloat contentWidth = self.headsArr.count*itemWidth;
    if (contentWidth < self.width) {
        contentWidth = self.width;
    }
    self.contentSize = CGSizeMake(contentWidth, itemWidth);
    for (int i = 0; i< self.headsArr.count; i++) {
        QLBaseButton *btn = self.subviews[i];
        CGRect rect = CGRectZero;
        if (self.direction == DirectionLeft) {
            rect = CGRectMake(i*(itemWidth-5),0, itemWidth, itemWidth);
        } else {
            rect = CGRectMake(contentWidth-itemWidth-i*(itemWidth-5), 0, itemWidth, itemWidth);
        }
        btn.frame = rect;
        [btn roundBorderWidth:1 borderColor:[UIColor clearColor]];
        
        if (!CGRectContainsRect(self.bounds, btn.frame)) {
            btn.hidden = YES;
        } else {
            btn.hidden = NO;
        }
    }
    
}
- (void)setHeadsArr:(NSArray *)headsArr {
    _headsArr = headsArr;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i< self.headsArr.count; i++) {
        QLBaseButton *btn = [[QLBaseButton alloc]init];
        btn.light = NO;
        btn.tag = i+100;
        [btn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        //设置图片
        if ([self.headsArr[i] isKindOfClass:[NSString class]]) {
            [btn sd_setImageWithURL:[NSURL URLWithString:self.headsArr[i]] forState:UIControlStateNormal];
            
        } else {
            [btn sd_setImageWithURL:[NSURL URLWithString:EncodeStringFromDic(self.headsArr[i], @"head_pic")] forState:UIControlStateNormal];
        }
        
        if (self.headDelegate&&[self.headDelegate respondsToSelector:@selector(setItemIndex:Obj:)]) {
            [self.headDelegate setItemIndex:i Obj:btn];
        }
    }
    [self setNeedsLayout];
}
- (void)setDirection:(StartDirection)direction {
    _direction = direction;
    [self setNeedsLayout];
}
//头像点击
- (void)btnClick:(UIButton *)sender {
    NSInteger index = sender.tag-100;
    if (self.headDelegate&&[self.headDelegate respondsToSelector:@selector(clickItemIndex:Obj:)]) {
        [self.headDelegate clickItemIndex:index Obj:sender];
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
