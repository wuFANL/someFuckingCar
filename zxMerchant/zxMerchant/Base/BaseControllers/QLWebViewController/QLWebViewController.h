//
//  QLWebViewController.h
//  IntegralSinks
//
//  Created by 乔磊 on 2018/3/9.
//  Copyright © 2018年 NineZero. All rights reserved.
//

#import "QLViewController.h"
@class QLWebViewController;
@protocol QLWebViewControllerDelegate <NSObject>
@optional
/*
 *webView加载
 */
- (void)webView:(WKWebView *)webView didFinish:(WKNavigation *)navigation;
@end
@interface QLWebViewController : QLViewController
/*
 *导航栏标题
 */
@property(nonatomic,strong) NSString *titleStr;
/*
 *加载地址
 */
@property(nonatomic,strong) NSString *loadURLStr;
/*
 *webView
 */
@property(nonatomic,strong) QLBaseWebView *webView;
/**
 *代理
 */
@property (nonatomic, weak) id<QLWebViewControllerDelegate> delegate;
@end
