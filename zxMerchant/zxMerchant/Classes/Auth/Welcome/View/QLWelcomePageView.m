//
//  QLWelcomePageView.m
//  zxMerchant
//
//  Created by lei qiao on 2021/6/7.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLWelcomePageView.h"
@interface QLWelcomePageView()


@end
@implementation QLWelcomePageView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).offset(-130);
    }];
    
    [self addSubview:self.pageControl];
}

#pragma mark - Lazy
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}
- (QLBasePageControl *)pageControl {
    if (!_pageControl) {
        CGFloat width = 8*2+18+5*2;
        _pageControl = [[QLBasePageControl alloc] initWithFrame:CGRectMake((self.width-width)*0.5, self.height-40,width , 8)];
        _pageControl.pageNum = 3;
        _pageControl.pageSize = CGSizeMake(8, 8);
        _pageControl.currentChange = 10;
        _pageControl.space = 5;
        _pageControl.currentImage = [UIImage imageNamed:@"currentPageImge"];
        _pageControl.defaultImage = [UIImage imageNamed:@"defaultPageImge"];
        
    }
    return _pageControl;
}
@end
