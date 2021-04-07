//
//  QLTableBackgroundView.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/8.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBaseBackgroundView.h"
#import "UIView+QLUtil.h"
@interface QLBaseBackgroundView()


@end

@implementation QLBaseBackgroundView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self addSubView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat centerY = self.centerY-64;
    //图片
    self.imageView.center = CGPointMake(self.centerX, centerY+self.offset);
    if (self.imageView.image) {
        self.imageView.size = CGSizeMake(85, 85);
        self.imageView.contentMode = UIViewContentModeCenter;
    } else {
        self.imageView.size = CGSizeMake(0, 0);
    }
    //文本
    self.placeholderBtn.frame = CGRectMake(0, self.imageView.centerY+(self.imageView.width*0.5)+20, self.width, 40);
    self.placeholderBtn.centerX = self.centerX;
}
//添加子空间
- (void)addSubView {
    //添加图片
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage imageNamed:@"loadingError"];
    [self addSubview:self.imageView];
    
    //添加文本
    self.placeholderBtn = [[QLBaseButton alloc]initWithFrame:CGRectMake(0, self.centerY-64+(self.imageView.width*0.5)+20, self.width, 40)];
    self.placeholderBtn.light = NO;
    self.placeholderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.placeholderBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.placeholderBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.placeholderBtn addTarget:self action:@selector(placeholderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.placeholderBtn];
}
//设置图片
- (void)setImageName:(NSString *)imageName {
    if(imageName.length == 0) {
        self.imageView.hidden = YES;
        self.imageView.height = 0;
        [self setOffset:0];
    } else {
        self.imageView.hidden = NO;
        self.imageView.height = 85;
        self.imageView.image = [UIImage imageNamed:imageName];
    }
    
}
//设置文本
- (void)setPlaceholder:(NSString *)placeholder {
    [self.placeholderBtn setTitle:placeholder forState:UIControlStateNormal];
}
//设置偏移
- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    [self layoutIfNeeded];
}
- (void)placeholderBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickPlaceholderBtn:)]) {
        [self.delegate clickPlaceholderBtn:sender];
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
