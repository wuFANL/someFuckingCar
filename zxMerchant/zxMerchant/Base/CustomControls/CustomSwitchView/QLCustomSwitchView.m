//
//  QLCustomSwitchView.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/9/28.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLCustomSwitchView.h"

@interface QLCustomSwitchView()
/**
 *点中按钮
 */
@property (nonatomic, strong) UIButton *selectBtn;
/**
 *背景图片
 */
@property (nonatomic, strong) UIImage *backgroundImage;
/**
 *当前按钮图片
 */
@property (nonatomic, strong) UIImage *currentImage;
/**
 *第一个标题
 */
@property (nonatomic, strong) NSString *firstTitle;
/**
 *第二个标题
 */
@property (nonatomic, strong) NSString *secondTitle;
@end
@implementation QLCustomSwitchView
- (instancetype)initWithFrame:(CGRect)frame FirstTitle:(NSString *)firstTitle SecondTitle:(NSString *)secondTitle BackgroundImage:(UIImage *)backgroundImage CurrentImage:(UIImage *)currentImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.firstTitle = firstTitle;
        self.secondTitle = secondTitle;
        self.currentImage = currentImage;
        self.backgroundImage = backgroundImage;
        //初始化设置
        [self viewSetting];
    }
    return self;
}

- (void)viewSetting {
    //背景图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.image = _backgroundImage;
    [self addSubview:imageView];
    //添加按钮
    for (int i = 0; i < 2; i++) {
        QLBaseButton *btn = [[QLBaseButton alloc]initWithFrame:CGRectMake(i*self.width*0.5, 0, self.width*0.5, self.height)];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = 10+i;
        if (i == 0) {
           [btn setTitle:_firstTitle forState:UIControlStateNormal];
            self.firstBtn = btn;
        } else {
            [btn setTitle:_secondTitle forState:UIControlStateNormal];
            self.secondBtn = btn;
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    //默认选中
    self.selectIndex = 0;
}
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    //选中变化
    QLBaseButton *btn = [self viewWithTag:selectIndex+10];
    self.selectBtn = btn;
    for (int i = 0; i < 2; i++) {
        [self btnChange:10+i];
    }
    
}
- (void)btnClick:(UIButton *)sender {
    self.selectIndex = sender.tag-10;
    self.selectBlcok(self.selectIndex);
}

- (void)btnChange:(NSInteger)btnTag {
    QLBaseButton *btn = [self viewWithTag:btnTag];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    if (btnTag == self.selectBtn.tag) {
        [btn setBackgroundImage:_currentImage forState:UIControlStateNormal];
        
        if (btnTag == 10) {
            btn.width = self.width*0.5+5;
        } else {
            btn.width = self.width*0.5+5;
            btn.x = self.width*0.5-5;
        }
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        if (btnTag == 10) {
            btn.width = self.width*0.5-5;
        } else {
             btn.x = self.width*0.5+5;
             btn.width = self.width*0.5-5;
        }
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
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
