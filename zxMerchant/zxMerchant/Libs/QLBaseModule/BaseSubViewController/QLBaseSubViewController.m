//
//  QLBaseSubViewController.m
//  JSTY
//
//  Created by 乔磊 on 2018/5/8.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLBaseSubViewController.h"

@interface QLBaseSubViewController ()
@property (nonatomic, weak) UIViewController *currentViewController;
@end

@implementation QLBaseSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundView.frame = self.view.bounds;
    self.backgroundView.hidden = NO;
    
}
- (void)viewDidLayoutSubviews {
    for (UIViewController *vc in self.childViewControllers) {
        vc.view.frame = self.view.bounds;
    }
}
- (void)setNeedGestureRecognizer:(BOOL)needGestureRecognizer {
    _needGestureRecognizer = needGestureRecognizer;
    if (needGestureRecognizer) {
        //添加滑动手势
        [self addGestureRecognizer];
    }
}
//轻扫手势
- (void)addGestureRecognizer {
    //创建轻扫手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    //设置方向
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    //将手势添加到 视图中
    [self.backgroundView addGestureRecognizer:leftSwipe];
    [self.backgroundView addGestureRecognizer:rightSwipe];
}
- (void)swipe:(UISwipeGestureRecognizer*)sender {
    //页面切换
    NSInteger index = self.currentViewController.view.tag-999;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (index < 2) {
            index += 1;
        }
        
    } else {
        if (index > 0) {
            index -= 1;
        }
    }
    [self viewChangeAnimation:index];
}
//设置子页面
- (void)setSubVCArr:(NSArray<UIViewController *> *)subVCArr {
    _subVCArr = subVCArr;
    if (subVCArr.count > 0 ) {
        for (int i = 0;i < subVCArr.count;i++) {
            UIViewController *vc = subVCArr[i];
            vc.view.tag = 999+i;
            [self addChildViewController:vc];
            if (i == 0) {
                [self.backgroundView addSubview:vc.view];
                self.currentViewController = vc;
            }
        }
    }
}
//页面变化动画
- (void)viewChangeAnimation:(NSInteger)index {
    if (index < self.childViewControllers.count) {
        UIViewController *viewController = self.childViewControllers[index];
        if (self.currentViewController.view != viewController.view) {
            [self.currentViewController.view removeFromSuperview];
            
            [self.backgroundView addSubview:viewController.view];
            //View转换动画
            CATransition *animation = [CATransition animation];
            //当前索引
            NSInteger originalIndex = [self.childViewControllers indexOfObject:self.currentViewController];
            animation.type = kCATransitionMoveIn;
            animation.subtype = index > originalIndex ? kCATransitionFromRight:kCATransitionFromLeft;
            animation.duration = 0.3;
            [self.backgroundView.layer addAnimation:animation forKey:nil];
            self.currentViewController = viewController;
            //页面变化代理
            if (self.delegate &&[self.delegate respondsToSelector:@selector(subViewChange:IndexPath:)]) {
                [self.delegate subViewChange:self.currentViewController IndexPath:index];
            }
        }
    } else {
        QLLog(@"下标越界");
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark-  Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
