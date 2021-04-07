//
//  QLBannerView.m
//  TheOneCampus
//
//  Created by 乔磊 on 2017/8/8.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBannerView.h"
#import "QLBasePageControl.h"
#import "QLBaseButton.h"

#define SlidingSpeed 3
#define pageChange 0
@interface QLBannerView()<UIScrollViewDelegate>
@property (nonatomic, strong) id<QLBannerViewDelegate> currentSelf;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *btnArr;
@end
@implementation QLBannerView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self defaultSet];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self defaultSet];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame HavePageControl:(BOOL)havePage Delegate:(id<QLBannerViewDelegate>)currentSelf {
    if (self == [super initWithFrame:frame]) {
        self.frame = frame;
        self.currentSelf = currentSelf;
        self.havePage = havePage;
        self.delegate = currentSelf;
        
        [self defaultSet];
        
    }
    return self;
}

- (void)layoutSubviews {
    self.scrollView.frame = CGRectMake(0, 0, self.width, self.height);
    //scrollView内容大小
    self.scrollView.contentSize = CGSizeMake(self.width*(_imagesArr.count==1?1:_imagesArr.count+2), self.height);
    
    self.pageControl.center = CGPointMake(self.width*0.5, self.height-10);
    
    for (int i = 0;i<self.btnArr.count;i++) {
        UIButton *btn = self.btnArr[i];
        btn.frame = CGRectMake(self.width * i, 0,self.width , self.height);
    }
}

- (void)defaultSet {
    self.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    //scrollView
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
}
- (void)setHavePage:(BOOL)havePage {
    _havePage = havePage;
    //分页点
    if (havePage) {
        self.pageControl = [[QLBasePageControl alloc]initWithFrame:CGRectZero];
        CGSize pageSize = CGSizeMake(6, 6);
        CGFloat space = 8;
        self.pageControl.pageSize = pageSize;
        self.pageControl.space = space;
        self.pageControl.currentChange = pageChange;
        self.pageControl.defaultImage = self.defaultPageImage?self.defaultPageImage:[UIImage imageNamed:@"defaultPage"];
        self.pageControl.currentImage = self.currentPageImage?self.currentPageImage:[UIImage imageNamed:@"pageCurrent"];
        //当前 选中的时第几个点  默认不设置是0
        self.pageControl.currentPage = 0;
        
    }
}
- (void)setImagesArr:(NSArray *)imagesArr {
    _imagesArr = imagesArr;
    [self.timer invalidate];
    self.timer = nil;
    
    if (_imagesArr.count > 0) {
        //设置分页
        if (self.pageControl) {
            NSInteger pageNum = _imagesArr.count;
            CGFloat width = (_pageControl.pageSize.width+_pageControl.space)*(pageNum-1)+_pageControl.pageSize.width;
            self.pageControl.pageNum = pageNum;
            self.pageControl.size = CGSizeMake(width, self.pageControl.pageSize.height);
            [self addSubview:self.pageControl];
        }
        
        //添加图片
        [self addImages];
        //创建手势
        if (_imagesArr.count > 1) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            longPress.minimumPressDuration = 1;
            [self.scrollView addGestureRecognizer:longPress];
            //增加定时器
            self.timer = [NSTimer scheduledTimerWithTimeInterval:SlidingSpeed target:self selector:@selector(scrollImageView) userInfo:nil repeats:YES];
        }
        //当数据大于1时，设置默认第一张
        if (_imagesArr.count > 1) {
            [self.scrollView setContentOffset:CGPointMake(self.width , 0) animated:NO];
        }
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}
- (void)addImages {
    for (UIButton *btn in self.btnArr) {
        [btn removeFromSuperview];
    }
    [self.btnArr removeAllObjects];
    
    for (int i = 0; i < (_imagesArr.count==1?1:_imagesArr.count+2); i++) {
        QLBaseButton *imageBtn = [[QLBaseButton alloc]init];
        imageBtn.light = NO;
        [imageBtn setContentMode:UIViewContentModeScaleAspectFill];
        int index = 0;
        if (i == 0) {
            index = (int)_imagesArr.count-1;
            imageBtn.tag = 10+_imagesArr.count;
        } else if (i == _imagesArr.count+1){
            index = 0;
            imageBtn.tag = 11;
        } else{
            index = i-1;
            imageBtn.tag = 10+i;
        }
        if ([self.delegate respondsToSelector:@selector(bannerView:ImageData:Index:ImageBtn:)]) {
            [self.delegate bannerView:self ImageData:_imagesArr Index:index ImageBtn:imageBtn];
        }
        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:imageBtn];
        [self.btnArr addObject:imageBtn];
    }
}
- (void)imageBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bannerView:ImageClick:Index:ImageBtn:)]) {
        [self.delegate bannerView:self ImageClick:_imagesArr Index:sender.tag-10-1 ImageBtn:sender];
    }
}
- (void)longPress:(UILongPressGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.timer invalidate];
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:SlidingSpeed target:self selector:@selector(scrollImageView) userInfo:nil repeats:YES];
    }
}
- (void)scrollImageView {
    [self.scrollView setContentOffset:CGPointMake(_scrollView.width * self.page, 0) animated:YES];
    self.page++;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat fScroll = scrollView.contentOffset.x / scrollView.frame.size.width;
    int scroll = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    self.page = scroll;
    NSInteger currentPage = scroll == 0?_imagesArr.count-1:scroll == _imagesArr.count+1?0:scroll-1;
    _pageControl.currentPage = currentPage;
    if (scroll == 0) {
        if (fScroll < 0.009) {
            [self.scrollView setContentOffset:CGPointMake(self.width*_imagesArr.count, 0) animated:NO];
        }
        
    } else if(scroll == _imagesArr.count+1){
        if (fScroll > _imagesArr.count+0.999) {
            [self.scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
        }
        
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(bannerView:ImageData:CurrentPage:)]) {
        [self.delegate bannerView:self ImageData:self.imagesArr CurrentPage:currentPage];
    }
    
}
- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark- 懒加载
- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
