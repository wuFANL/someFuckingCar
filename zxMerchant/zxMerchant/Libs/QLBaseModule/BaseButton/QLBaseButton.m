//
//  QLBaseButton.m
//  Integral
//
//  Created by 乔磊 on 2019/4/3.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBaseButton.h"

@implementation QLBaseButton
- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self defaultSet];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self defaultSet];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //去除高亮效果
    [self addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
}
//默认设置
- (void)defaultSet {
    self.light = YES;
    
}
//保证所有touch事件button的highlighted属性为NO
- (void)preventFlicker:(UIButton *)button {
    if (self.light) {
        self.highlighted = YES;
    } else {
        self.highlighted = NO;
    }
}
- (void)setHighlighted:(BOOL)highlighted {
    if (self.light) {
        [super setHighlighted:highlighted];
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
