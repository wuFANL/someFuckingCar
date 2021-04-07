//
//  QLBaseTextView.m
//  QLKit
//
//  Created by 乔磊 on 2018/3/19.
//  Copyright © 2018年 NineZero. All rights reserved.
//

#import "QLBaseTextView.h"
#import <objc/runtime.h>

#define placeholderSidesSpace 10
#define constraintSidesSpace 5
@interface QLBaseTextView()<UITextViewDelegate>
@property (nonatomic, assign) BOOL isAskingCanBecomeFirstResponder;
@property (nonatomic, assign) BOOL canEdit;

@end

@implementation QLBaseTextView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultConfig];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self defaultConfig];
    }
    return self;
}
//默认设置
- (void)defaultConfig {
    self.editable = YES;
    self.selectable = YES;
    //添加占位文本
    [self insertSubview:self.placeholderLB aboveSubview:self];
    //添加字数限制文本
    [self insertSubview:self.constraintLB aboveSubview:self];
    //默认显示占位文本
    self.showPlaceholder = YES;
    //默认显示限制文本
    self.showCountLimit = YES;
    //默认不限字数
    self.countLimit = 0;
    //代理
    self.delegate = self;
    //text的set方法赋值监听
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.placeholderLB.hidden == NO) {
        CGRect placeholderFrame = CGRectZero;
        if (self.showCenterPlaceholder) {
            placeholderFrame = CGRectMake(placeholderSidesSpace, placeholderSidesSpace, self.frame.size.width-placeholderSidesSpace*2, self.frame.size.height-placeholderSidesSpace*2);
        } else {
            CGSize titleSize = [self.placeholderLB.text boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.placeholderLB.font} context:nil].size;
            placeholderFrame = CGRectMake(placeholderSidesSpace, placeholderSidesSpace, self.frame.size.width-placeholderSidesSpace*2, titleSize.height+placeholderSidesSpace*2);
        }
        self.placeholderLB.frame = placeholderFrame;
        
        self.constraintLB.frame = CGRectMake(constraintSidesSpace, self.frame.size.height+self.contentOffset.y-32, self.frame.size.width-constraintSidesSpace*2, 30);
        
        
    }
    
}
//设置占位文本
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLB.text = _placeholder;
}
//字数限制的值
- (void)setCountLimit:(NSInteger)countLimit {
    _countLimit = countLimit;
    if (_countLimit == 0) {
        _constraintLB.text = @"不限";
    } else {
        _constraintLB.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)self.text.length,(long)_countLimit];
    }
}
//是否显示占位文本
- (void)setShowPlaceholder:(BOOL)showPlaceholder {
    _showPlaceholder = showPlaceholder;
    if (_showPlaceholder == YES) {
        self.placeholderLB.hidden  = NO;
    } else {
        self.placeholderLB.hidden  = YES;
    }
}
//是否显示字数限制文本
- (void)setShowCountLimit:(BOOL)showCountLimit {
    _showCountLimit = showCountLimit;
    
    if (_showCountLimit == YES) {
        self.constraintLB.hidden = NO;
    } else {
        self.constraintLB.hidden = YES;
    }
}
//是否显示长按菜单
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.showMenu) {
        return [super canPerformAction:action withSender:sender];
    }
    return NO;
}
#pragma mark- textView代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.tvDelegate respondsToSelector:@selector(textViewWillEditing:)]) {
        if (self.isAskingCanBecomeFirstResponder == NO) {
            self.isAskingCanBecomeFirstResponder = YES;
            self.canEdit = [self.tvDelegate textViewWillEditing:textView];
        } else {
            self.isAskingCanBecomeFirstResponder = NO;
        }
        return self.canEdit;
    }
    self.placeholderLB.hidden = YES;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.isAskingCanBecomeFirstResponder = NO;
    if (textView.text.length == 0) {
        self.placeholderLB.hidden = NO;
        //滑动到中心
        [self scrollRectToVisible:self.placeholderLB.bounds animated:YES];
    }
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length > 0) {
        self.placeholderLB.hidden = YES;
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeholderLB.hidden = YES;
    }
    //限制字数
    [self limitedWords:textView.text];
    
    if ([self.tvDelegate respondsToSelector:@selector(textViewTextChange:)]) {
        [self.tvDelegate textViewTextChange:self];
    }
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        NSString *content = change[NSKeyValueChangeNewKey];
        self.placeholderLB.hidden = content.length == 0?NO:YES;
        //限制字数
        [self limitedWords:content];
        
        if ([self.tvDelegate respondsToSelector:@selector(textViewTextChange:)]) {
            [self.tvDelegate textViewTextChange:self];
        }
        
    }
    
}
//字数限制
- (void)limitedWords:(NSString *)content {
    if (self.countLimit != 0) {
        NSString *lang = [self.textInputMode primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"]) {
            //获取高亮部分
            UITextRange *selectedRange = [self markedTextRange];
            //获取光标位置
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            //position为空输入完成，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (content.length > _countLimit) {
                    self.text = [content substringToIndex:_countLimit];
                }
            }
            
        } else {
            //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (content.length > _countLimit) {
                NSRange rangeIndex = [content rangeOfComposedCharacterSequenceAtIndex:_countLimit];
                if (rangeIndex.length == 1) {
                    //上限部分,字符长度为1
                    self.text = [content substringToIndex:_countLimit];
                } else {
                    NSRange rangeRange = [content rangeOfComposedCharacterSequencesForRange:NSMakeRange(0,_countLimit)];
                    self.text = [content substringWithRange:rangeRange];
                }
            }
        }
        self.constraintLB.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)self.text.length,(long)_countLimit];
    }
}
#pragma mark - Lazy
- (UILabel *)placeholderLB {
    if (!_placeholderLB) {
        _placeholderLB = [[UILabel alloc] init];
        _placeholderLB.font = [UIFont systemFontOfSize:13];
        _placeholderLB.textColor = [UIColor lightGrayColor];
        _placeholderLB.textAlignment = NSTextAlignmentLeft;
        _placeholderLB.numberOfLines = 0;
        _placeholderLB.userInteractionEnabled = NO;
        [_placeholderLB sizeToFit];
    }
    return _placeholderLB;
}
- (UILabel *)constraintLB {
    if (!_constraintLB) {
        _constraintLB = [[UILabel alloc] init];
        _constraintLB.font = [UIFont systemFontOfSize:12];
        _constraintLB.textColor = [UIColor lightGrayColor];
        _constraintLB.textAlignment = NSTextAlignmentRight;
        _constraintLB.numberOfLines = 1;
        _constraintLB.userInteractionEnabled = NO;
    }
    return _constraintLB;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"text"];
}
@end

@implementation UITextViewWorkaround

+ (void)executeWorkaround {
    if (@available(iOS 13.2, *)) {
        
    } else {
        const char *className = "_UITextLayoutView";
        Class cls = objc_getClass(className);
        if (cls == nil) {
            cls = objc_allocateClassPair([UIView class], className, 0);
            objc_registerClassPair(cls);
#if DEBUG
            printf("added %s dynamically\n", className);
#endif
        }
    }
}

@end
