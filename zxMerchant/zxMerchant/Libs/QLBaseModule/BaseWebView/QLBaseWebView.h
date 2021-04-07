//
//  QLBaseWebView.h
//  LoveSuguo
//
//  Created by 乔磊 on 2017/12/27.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class QLBaseWebView;
@protocol QLBaseWebViewDelegate <NSObject>
@optional
/**
 *获取标题
 */
- (void)webView:(WKWebView *)webView Title:(NSString *)title;
/**
 *获取加载进度
 */
- (void)webView:(WKWebView *)webView Progress:(double)progress;
@end

@interface QLBaseWebView : WKWebView
/**
 *是否显示滚动条(默认消失)
 */
@property (nonatomic, assign) BOOL showScrollBar;
/**
 *长按辅助菜单是否有效(默认无效)
 */
@property (nonatomic, assign) BOOL auxiliaryMenuValid;
/**
 *代理方法
 */
@property (nonatomic, weak) id<QLBaseWebViewDelegate> loadDelegate;
@end
