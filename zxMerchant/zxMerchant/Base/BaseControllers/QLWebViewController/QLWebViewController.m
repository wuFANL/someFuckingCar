//
//  QLWebViewController.m
//  IntegralSinks
//
//  Created by 乔磊 on 2018/3/9.
//  Copyright © 2018年 NineZero. All rights reserved.
//

#import "QLWebViewController.h"

@interface QLWebViewController ()<WKNavigationDelegate,WKUIDelegate,QLBaseWebViewDelegate>

@end

@implementation QLWebViewController
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.webView = [[QLBaseWebView alloc] init];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.loadDelegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    adjustsScrollViewInsets_NO(self.webView.scrollView, self);
    if (self.loadURLStr.length > 0) {
        self.webView.hidden = NO;
        [self webViewLoad];
    
    } else {
        self.webView.hidden = YES;
        self.showBackgroundView = YES;
    }
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.mas_offset(self.view.safeAreaInsets);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
}
#pragma mark - setter
//设置导航栏
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = [titleStr stringByRemovingPercentEncoding];
    self.navigationItem.title = self.titleStr;
}
//加载地址
- (void)setLoadURLStr:(NSString *)loadURLStr {
    _loadURLStr = loadURLStr;
    if (_loadURLStr.length == 0) {
        self.webView.hidden = YES;
        self.showBackgroundView = YES;
    } else {
        self.webView.hidden = NO;
        [self webViewLoad];
    }
    
}
#pragma mark - action
- (void)webViewLoad {
    if ([self.loadURLStr hasPrefix:@"http"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadURLStr]]];
    } else {
        [self.webView loadHTMLString:QLNONull(self.loadURLStr) baseURL:nil];
    }
}
#pragma mark - webView
//判断链接是否允许跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = [webView.URL.absoluteString stringByRemovingPercentEncoding];
    QLLog(@"%@",url);
    decisionHandler(WKNavigationActionPolicyAllow);
}
//拿到响应后决定是否允许跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    QLLog(@"createWebViewWithConfiguration");
    //假如是重新打开窗口的话
    if (!navigationAction.targetFrame.isMainFrame) {
       
    }
    return nil;
}
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
}
//当内容开始到达主帧时被调用（即将完成）
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
//加载完成
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [MBProgressHUD immediatelyRemoveHUD];
    self.showBackgroundView = NO;
    self.webView.hidden = NO;
    //代理
    if (self.delegate&&[self.delegate respondsToSelector:@selector(webView:didFinish:)]) {
        [self.delegate webView:webView didFinish:navigation];
    }
}
//加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    if (self.navigationController.navigationBar.isHidden) {
        self.navigationController.navigationBar.hidden = NO;
    }
    
    [MBProgressHUD immediatelyRemoveHUD];
    self.webView.hidden = YES;
    self.showBackgroundView = YES;
    if (self.loadURLStr.length == 0) {
        self.backgroundView.placeholder = @"加载地址为空";
    } else {
        self.backgroundView.placeholder = @"加载失败,请重新加载";
    }
    
}
//接收到警告面板
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}
//接收到确认面板
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}
//接收到输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    
}
//接收到js消息
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
   
}
@end
