//
//  QLBaseWebView.m
//  LoveSuguo
//
//  Created by 乔磊 on 2017/12/27.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBaseWebView.h"
#import "NSString+QLUtil.h"
#import "QLKitLogManager.h"

@interface QLBaseWebView ()

@end

@implementation QLBaseWebView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    //使用javaScript
    configuration.preferences.javaScriptEnabled = YES;
    //设置最小字号
    configuration.preferences.minimumFontSize = 0.0f;
    //JavaScript注入对象
    if (configuration.userContentController == nil) {
        configuration.userContentController = [[WKUserContentController alloc] init];
    }
    //是使用h5的视频播放器在线播放(YES), 还是使用原生播放器全屏播放
    configuration.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    configuration.requiresUserActionForMediaPlayback = NO;
    //设置是否允许画中画技术 在特定设备上有效
    configuration.allowsPictureInPictureMediaPlayback = YES;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    configuration.applicationNameForUserAgent = @"iOS";
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        [self defaultConfig];
    }
    return self;
}
//默认设置
- (void)defaultConfig {
    self.opaque = NO;
    //背景
    self.backgroundColor = [UIColor clearColor];
    //滚动条
    self.scrollView.showsVerticalScrollIndicator = NO;
    //同意手势前进后退
    self.allowsBackForwardNavigationGestures = NO;
    //长按辅助菜单是否有效
    self.auxiliaryMenuValid = NO;
    //添加监测网页加载进度的观察者
    [self addObserver:self forKeyPath:@"estimatedProgress" options:0 context:nil];
    //添加监测网页标题title的观察者
    [self addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)setShowScrollBar:(BOOL)showScrollBar {
    _showScrollBar = showScrollBar;
    self.scrollView.showsVerticalScrollIndicator = showScrollBar;
}
- (void)setAuxiliaryMenuValid:(BOOL)auxiliaryMenuValid {
    _auxiliaryMenuValid = auxiliaryMenuValid;
    NSMutableString *javascript = [NSMutableString string];
    if (auxiliaryMenuValid == NO) {
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [self.configuration.userContentController addUserScript:noneSelectScript];
    } else {
        [self.configuration.userContentController removeAllUserScripts];
    }
    
}
//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self) {
        QLLog(@"网页加载进度 = %f",self.estimatedProgress);
        //加载完毕
        if (self.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
        }
        if (self.loadDelegate&&[self.loadDelegate respondsToSelector:@selector(webView:Progress:)]) {
            [self.loadDelegate webView:self Progress:self.estimatedProgress];
        }
    } else if ([keyPath isEqualToString:@"title"]&& object == self){
        QLLog(@"网页标题 = %@",self.title);
        if (self.loadDelegate&&[self.loadDelegate respondsToSelector:@selector(webView:Title:)]) {
            [self.loadDelegate webView:self Title:self.title];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc {
    //移除观察者
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
}


@end
@implementation NSURLRequest(ForSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    
    return YES;
}
@end
