//
//  QLFloatingBallView.m
//  BORDRIN
//
//  Created by 乔磊 on 2018/8/3.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLFloatingBallView.h"
#define  screenWidth    [[UIScreen mainScreen] bounds].size.width
#define  screenHeight   [[UIScreen mainScreen] bounds].size.height
#define ballWidth 40
#define ballRight 15
#define ballBottom 80

@interface QLFloatingBallView()
@property (nonatomic, strong) UIImageView *bjImgView;
@property (nonatomic, weak) UIWindow *currentWindow;
@end
@implementation QLFloatingBallView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(screenWidth-ballWidth-ballRight, screenHeight-ballWidth-ballBottom-44, ballWidth, ballWidth);
        self.backgroundColor = [UIColor clearColor];
        self.hidden = NO;
        self.userInteractionEnabled = YES;
        //增加图片
        [self addSubview:self.bjImgView];
        [self.bjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        //点击
        [self addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
        //拖动
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(changeLocation:)];
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        
    }
    return self;
}
#pragma mark- set
//设置背景图
- (void)setBjImg:(UIImage *)bjImg {
    _bjImg = bjImg;
    self.bjImgView.image = bjImg;
}
#pragma mark- action
//悬浮球拖拽
- (void)changeLocation:(UIPanGestureRecognizer *)sender {
    UIWindow *appWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint panPoint = [sender locationInView:appWindow];
    CGFloat touchHeight = self.frame.size.height;
    //位置
    if(sender.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(screenWidth - left);
        CGFloat minSpace = MIN(left, right);
        CGPoint newCenter;
        CGFloat targetY = 0;
        
        //校正Y
        CGFloat viewHeight = screenHeight-(BottomOffset?88:64);
        CGFloat bottomLimit = (viewHeight - touchHeight/2.0 - (BottomOffset?(15+34):15));
        if (panPoint.y < 15 + touchHeight/2.0) {
            targetY = 15 + touchHeight/2.0;
        }else if (panPoint.y > bottomLimit) {
            targetY = bottomLimit;
        }else{
            targetY = panPoint.y;
        }
        
        if (minSpace == left) {
            newCenter = CGPointMake(touchHeight/2+ballRight, targetY);
        } else {
            newCenter = CGPointMake(screenWidth-(touchHeight/2+ballRight), targetY);
        }
        [UIView animateWithDuration:.25 animations:^{
            self.center = newCenter;
        }];
    }
    
}
//悬浮球点击
- (void)controlClick {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(controlClickAction:)]) {
        [self.delegate controlClickAction:self];
    }
}
//显示
- (void)show {
    self.hidden = NO;
    [self removeFromSuperview];
    [KeyWindow addSubview:self];
}
//隐藏
- (void)hidden {
    [self remove];
}
//移除
- (void)remove {
    [self removeFromSuperview];
}
#pragma mark - Lazy
- (UIImageView *)bjImgView {
    if (!_bjImgView) {
        _bjImgView = [[UIImageView alloc]init];
    }
    return _bjImgView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
