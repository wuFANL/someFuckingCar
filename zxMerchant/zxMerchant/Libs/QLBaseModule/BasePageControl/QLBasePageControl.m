//
//  QLBasePageControl.m
//  TheOneCampus
//
//  Created by 乔磊 on 2017/8/10.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBasePageControl.h"
#import "UIView+QLUtil.h"
@interface QLBasePageControl()


@end
@implementation QLBasePageControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.frame = frame;
        
        [self commonInit];
    }
        return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    //创建UIImageView
    [self addImageView];
    //布局
    [self currentPageChange];
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.canClickLower = NO;
    //kvc
    [self addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addImageView {
    for (UIImageView *imgView in self.subviews) {
        [imgView removeFromSuperview];
    }
    CGFloat distance = _space+_pageSize.width;
    for (int i = 0; i < self.pageNum; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(distance*i, 0, _pageSize.width, _pageSize.height)];
        imageView.tag = 100+i;
        if (self.canClick == YES) {
            //1.创建手势  点击
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            //设置属性
            //点几次响应手势
            tap.numberOfTapsRequired = 1;
            //几个触摸点， 点击
            tap.numberOfTouchesRequired = 1;
            //将手势添加到视图中
            [imageView addGestureRecognizer:tap];
            tap.view.tag = imageView.tag;
        }
        if (self.pageNum == 1) {
            imageView.center = self.center;
        }
        [self addSubview:imageView];
    }
}
- (void)tap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(pageClickIndex:)]) {
        [self.delegate pageClickIndex:tap.view.tag-100];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentPage"]) {
        [self currentPageChange];
    }
}
- (void)currentPageChange {
    for (int i = 0; i < self.pageNum; i++) {
        UIImageView *imageView = [self viewWithTag:100+i];
        if (i == self.currentPage) {
            imageView.image = _currentImage;
            imageView.frame = CGRectMake(i *(_pageSize.width+_space), (self.height-_pageSize.height)*0.5, _pageSize.width+_currentChange, _pageSize.height);
        } else {
            imageView.image = _defaultImage;
            imageView.frame = CGRectMake(i *(_pageSize.width+_space)+(i<self.currentPage?0:_currentChange), (self.height-_pageSize.height)*0.5, _pageSize.width, _pageSize.height);
        }
    }
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    } else {
        return hitView;
    }
}
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"currentPage"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
