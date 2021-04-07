//
//  QLFullScreenImgView.m
//  BORDRIN
//
//  Created by 乔磊 on 2018/10/9.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLFullScreenImgView.h"
@interface QLFullScreenImgView()<UIScrollViewDelegate,QLBaseViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imgView;
@end
@implementation QLFullScreenImgView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
        self.viewDelegate = self;
    }
    return self;
}
- (void)setImgUrl:(NSString *)imgUrl {
    _imgUrl = QLNONull(imgUrl);
    [self showBigImage:self.imgUrl];
}
- (void)setImg:(UIImage *)img {
    _img = img;
    [self showBigImage:self.img];
}
#pragma mark 显示大图片
- (void)showBigImage:(id)obj {
    [self addSubview:self.scrollView];
    //创建关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(removeBigImage) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setFrame:CGRectMake(ScreenWidth-50, 44, 40, 40)];
    [self addSubview:closeBtn];
    //scrollView
    UIScrollView *s = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth, ScreenHeight)];
    s.backgroundColor = [UIColor clearColor];
    s.contentSize = CGSizeMake(ScreenWidth+2,ScreenHeight+2);
    s.delegate = self;
    s.minimumZoomScale = 1.0;
    s.maximumZoomScale = 3.0;
    [s setZoomScale:1.0];
    [self.scrollView addSubview:s];
    //图片
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth, ScreenHeight)];
    if ([obj isKindOfClass:[NSString class]]) {
        [imageview sd_setImageWithURL:[NSURL URLWithString:obj]];
    } else if ([obj isKindOfClass:[UIImage class]]) {
        imageview.image = obj;
    }
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.userInteractionEnabled =YES;
    [s addSubview:imageview];
    self.imgView = imageview;
    //图片双击
    UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    
    //单击关闭
    UITapGestureRecognizer *oneTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTap:)];
    [oneTap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:oneTap];
    
     [oneTap requireGestureRecognizerToFail:doubleTap];
}
#pragma mark-  单击关闭
- (void)oneTap:(UIGestureRecognizer *)gesture {
    [self removeBigImage];
}
#pragma mark-  双击图片放大的逻辑
- (void)handleDoubleTap:(UIGestureRecognizer *)gesture {
    float newScale = [self.scrollView zoomScale] * 1.5;//每次双击放大倍数
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / scale;
    zoomRect.size.width  =self.frame.size.width  / scale;
    //双击图片的时候 以整个屏幕中心为基点 调整放大后的图片的原点位置
    zoomRect.origin.x = self.scrollView.center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = self.scrollView.center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}
#pragma mark-  scrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView ==self.scrollView){
        for (UIScrollView *s in scrollView.subviews){
            if ([s isKindOfClass:[UIScrollView class]]){
                [s setZoomScale:1.0]; //scrollView每滑动一次将要出现的图片较正常时候图片的倍数（将要出现的图片显示的倍数）
            }
        }
    }
}
- (void)removeBigImage {
    [self hidden];
}
- (void)hideMaskViewEvent {
    [self hidden];
}
- (void)show {
    [KeyWindow addSubview:self];
}
- (void)hidden {
    [self removeFromSuperview];
}
#pragma mark - Lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.scrollView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        //设置分页
        self.scrollView.pagingEnabled = YES;
        // 设置内容大小
        self.scrollView.contentSize = CGSizeMake(ScreenWidth,ScreenHeight);
        self.scrollView.delegate = self;
    }
    return _scrollView;
}

@end
