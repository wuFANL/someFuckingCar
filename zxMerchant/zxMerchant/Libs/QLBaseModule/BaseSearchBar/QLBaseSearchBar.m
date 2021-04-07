//
//  QLBaseSearchBar.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/9/27.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLBaseSearchBar.h"
#import "UIView+QLUtil.h"
// icon宽度
static CGFloat const searchIconW = 20.0;

@interface QLBaseSearchBar()<UITextFieldDelegate>
// placeholder 和icon 与间隙的整体宽度
@property (nonatomic, assign) CGFloat placeholderWidth;

@end
@implementation QLBaseSearchBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultSet];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
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
- (void)layoutSubviews {
    [super layoutSubviews];
    // 重设field的frame
    self.textField.frame = CGRectMake(10.0, 5, self.frame.size.width-20.0, self.frame.size.height-10.0);
    //画圆角
    if (_isRound == YES) {
        [self roundRectCornerRadius:self.height*0.5 borderWidth:1 borderColor:self.bjColor];
    }
    //提示文字居中
    if (self.hasCentredPlaceholder == YES) {
        [self setCenterPosition];
    }
}
#pragma mark - setter
//设置不能编辑，能点击回调
- (void)setNoEditClick:(BOOL)noEditClick {
    _noEditClick = noEditClick;
    if (noEditClick) {
        self.textField.enabled = NO;
    } else {
        self.textField.enabled = YES;
    }
}
//设置背景色
- (void)setBjColor:(UIColor *)bjColor {
    _bjColor = bjColor;
    self.backgroundColor = bjColor;
    [self setSearchFieldBackgroundImage:[UIImage createImageWithColor:bjColor Size:self.textField.size] forState:UIControlStateNormal];
    [self.textField setBackgroundColor:bjColor];
}
//修改占位字符字号
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    //设置占位符样式
    [self setAttributedPlaceholder];
}
//修改占位字符颜色
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    //设置占位符样式
    [self setAttributedPlaceholder];
}
//设置占位符样式
- (void)setAttributedPlaceholder {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = self.placeholderColor;
    attributes[NSFontAttributeName] = self.placeholderFont;
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attributes];
    self.textField.attributedPlaceholder = attributedPlaceholder;
}
//位置改变默认
- (void)setDefaultPosition {
    [self setPositionAdjustment:self.defaultOffset forSearchBarIcon:UISearchBarIconSearch];
}
//位置改变中间
- (void)setCenterPosition {
    [self setPositionAdjustment:UIOffsetMake((self.textField.frame.size.width-self.placeholderWidth-searchIconW-20)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
}
#pragma mark - action
//搜索栏点击
- (void)searchBarTouch:(UITapGestureRecognizer *)tap {
    if (self.noEditClick) {
        if ([self.extenDelegate respondsToSelector:@selector(noEditClick)]) {
            [self.extenDelegate noEditClick];
        }
    }
}
//开始编辑的时候重置为靠左
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (@available(iOS 11.0, *)) {
        [self setDefaultPosition];
    }
    return YES;
}
//结束编辑的时候设置为居中
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (@available(iOS 11.0, *)) {
        if(_hasCentredPlaceholder == YES) {
            [self setCenterPosition];
        }
    }
    return YES;
}
//默认设置
- (void)defaultSet {
    self.backgroundImage = [[UIImage alloc] init];
    //默认占位文本
    self.placeholder = @"请输入";
    //默认占位文本大小
    self.placeholderFont = [UIFont systemFontOfSize:13];
    //默认占位位置
    self.defaultOffset = UIOffsetMake(10, 0);
    [self setDefaultPosition];
    //输入框
    [self.textField setFont:[UIFont systemFontOfSize:14]];
    self.textField.delegate = self;
    //搜索框点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchBarTouch:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}
#pragma mark - Lazy
- (UITextField *)textField {
    if (!_textField) {
        if (@available(iOS 13.0, *)) {
            _textField = self.searchTextField;
        } else {
            _textField =  [self valueForKey:@"_searchField"];
        }
    }
    return _textField;
}
- (CGFloat)placeholderWidth {
    if (!_placeholderWidth) {
        // 计算placeholder、icon、icon和placeholder间距的总宽度
        CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.placeholderFont} context:nil].size;
        _placeholderWidth = size.width;
    }
    return _placeholderWidth;
}


@end
