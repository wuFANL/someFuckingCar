//
//  QLWelcomeViewController.m
//  Template
//
//  Created by jgs on 2017/6/9.
//  Copyright © 2017年 QL. All rights reserved.
//

#import "QLWelcomeViewController.h"
#import "QLWelcomePageView.h"

@interface QLWelcomeViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSString *loadStr;
@end

@implementation QLWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //功能数据
    [self getFunData];
    //预加载个人信息
    [self getMeInfo];
    //增加ScrollView
    [self addScrollView];
    
    self.page = 1;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollImageView) userInfo:nil repeats:YES];
}
#pragma mark - network
//功能数据
- (void)getFunData {
    [[QLToolsManager share] getFunData:^(id result, NSError *error) {
        if (!error) {
            [AppDelegateShare initTabBarVC];
        } else {
            if([error.domain containsString:@"商户异常"]||[error.domain containsString:@"重新登陆"]) {
                [QLUserInfoModel loginOut];
                [AppDelegateShare initLoginVC];
            } else {
                QLCustomAlertView *alertView = [[QLToolsManager share] alert:@"数据获取失败" handler:^(NSError *error) {
                    if (!error) {
                        if (!error) {
                            //重新获取
                           [self getFunData];
                        }
                    }
                }];
                [alertView.confirmBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            }
        }
    }];
}
//个人信息
- (void)getMeInfo {
    [[QLToolsManager share] getMeInfoRequest:^(id result, NSError *error) {
        
    }];
    
}
#pragma mark - Common
- (void)addScrollView {
    CGSize screenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height);
    //设置scrollView的内容大小
    self.scrollView.contentSize = CGSizeMake(screenSize.width * self.imageArr.count, screenSize.height);
    self.scrollView.delegate = self;
    [self addImageViewWithWidth:screenSize.width withHeight:screenSize.height];
    self.scrollView.bounces = NO;
    //创建手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 1;
    [self.scrollView addGestureRecognizer:longPress];
}
- (void)addImageViewWithWidth:(CGFloat)screenWidth withHeight:(CGFloat)screenHeight {
    
    for (int i = 0; i < self.imageArr.count; i++) {
        QLWelcomePageView *pageView = [[QLWelcomePageView alloc] initWithFrame:CGRectMake(screenWidth * i, 0,screenWidth , screenHeight)];
        pageView.pageControl.currentPage = i;
        //创建imageView，加入到scrollView
        pageView.imgView.image = [UIImage imageNamed:self.imageArr[i]];
        if (i == self.imageArr.count-1) {
            //添加button，跳转
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((screenWidth - 115)/2,screenHeight-32-(BottomOffset?34:0), 115, 35)];
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"greenBj_332"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(jumpInterface) forControlEvents:UIControlEventTouchUpInside];
            [pageView addSubview:button];
        }
        [self.scrollView addSubview:pageView];
    }
    
}
- (void)longPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.timer invalidate];
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollImageView) userInfo:nil repeats:YES];
    }
}
- (void)scrollImageView {
    [self.scrollView setContentOffset:CGPointMake(self.view.width * self.page, 0) animated:YES];
    self.page++;
    if (self.page == _imageArr.count+1) {
        [self jumpInterface];
    }
}
- (void)jumpInterface {
    if ([QLUserInfoModel getLocalInfo].isLogin) {
        [AppDelegateShare initTabBarVC];
    } else {
        [AppDelegateShare initLoginVC];
    }
    [self.timer invalidate];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int scroll = round(scrollView.contentOffset.x / scrollView.frame.size.width) ;
    self.page = scroll;
    
}
#pragma mark -懒加载
- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [@[@"welcome1",@"welcome2",@"welcome3"] mutableCopy];
    }
    return _imageArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
