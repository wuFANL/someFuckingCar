//
//  QLBaseView.m
//  Integral
//
//  Created by 乔磊 on 2019/4/3.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBaseView.h"

@implementation QLBaseView
//开始点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.viewDelegate respondsToSelector:@selector(hiddenViewEvent)]) {
        //启用遮罩代理的点击隐藏
        CGPoint point = [[touches anyObject] locationInView:self];
        if (self.subviews.count == 0) {
            [self remove];
        } else {
            for (UIView *view in self.subviews) {
                if (view != self&&self.canClickLower == NO) {
                    point = [view.layer convertPoint:point fromLayer:self.layer];
                    if (![view.layer containsPoint:point]||view.hidden == YES) {
                        [self remove];
                    }
                    
                }
            }
        }
    }
    
}
//点击事件传递
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        if (self.canClickLower) {
            return nil;
        } else {
            return hitView;
        }
    } else {
        return hitView;
    }
}
//删除页面
- (void)remove {
    if (self.viewDelegate&&[self.viewDelegate respondsToSelector:@selector(hiddenViewEvent)]) {
        [self.viewDelegate hiddenViewEvent];
    } else {
        [self removeSubviews];
        [self removeFromSuperview];
        
    }
    
}
//删除子view
- (void)removeSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
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
