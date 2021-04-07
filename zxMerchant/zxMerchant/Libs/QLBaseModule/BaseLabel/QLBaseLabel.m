//
//  QLBaseLabel.m
//  test
//
//  Created by 乔磊 on 2019/4/6.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBaseLabel.h"
#import <CoreText/CoreText.h>
#import "NSString+QLUtil.h"
#import "QLBaseView.h"

@interface QLBaseLabel()
@property (nonatomic, strong) QLBaseView *backgroundView;
@property (nonatomic, copy) NSArray <NSString *> *textArr;
@property (nonatomic, copy) NSArray <UILabel *> *labelArr;
@end

@implementation QLBaseLabel
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
        [self defaultSet];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = 0.0;
    CGFloat height = self.frame.size.height;
    if (self.autoFit) {
        for (UILabel *lb in self.labelArr) {
            width += lb.frame.size.width;
            height = lb.frame.size.height;
        }
        
    } else {
        width = self.frame.size.width;
    }
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    self.frame = frame;
    self.backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
}

#pragma mark - setter
//设置是否滚动
- (void)setIsScroll:(BOOL)isScroll {
    _isScroll = isScroll;
    if (isScroll) {
        [self addSubview:self.backgroundView];
        [self setText:self.text];
    } else {
        [self.backgroundView removeSubviews];
        self.backgroundView = nil;
        for (UILabel *lb in self.labelArr) {
            [lb removeFromSuperview];
        }
    }
    
}
//设置是否可以点击
- (void)setIsTapAction:(BOOL)isTapAction {
    _isTapAction = isTapAction;
    self.userInteractionEnabled = isTapAction;
}
//设置字体颜色
- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    if (self.isScroll) {
        for (UILabel *lb in self.labelArr) {
            lb.textColor = textColor;
        }
    }
    
}
//设置背景
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    if (self.backgroundView) {
        self.backgroundView.backgroundColor = backgroundColor;
    }
}
//设置字体
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    for (UILabel *lb in self.labelArr) {
        lb.font = font;
    }
}
//设置是否需要自适应
- (void)setAutoFit:(BOOL)autoFit {
    _autoFit = autoFit;
    
}
//设置文本
- (void)setText:(NSString *)text {
    [super setText:text];
    if (text.length != 0&&self.isScroll) {
        [self clipScrollText:text operateHandler:^(NSMutableArray<NSString *> *textArr, NSMutableArray<UILabel *> *labelArr) {
            [self showScrollAnimiationWithTextArr:textArr lableArr:labelArr];
        }];
    }
    
}
#pragma mark - action
//默认设置
- (void)defaultSet {
    self.textColor = [UIColor darkTextColor];
    self.animateDuration = 0.25;
    
}
//截取文本内容
- (void)clipScrollText:(NSString *)text operateHandler:(void (^) (NSMutableArray<NSString *> *textArr,NSMutableArray<UILabel *> *labelArr))handler {
    NSMutableArray <NSString *> *textArr = [[NSMutableArray alloc] initWithCapacity:text.length];
    NSMutableArray <UILabel *> *labelArr = [[NSMutableArray alloc] initWithCapacity:text.length];
    
    for (NSInteger i = 0 ; i < text.length; i ++) {
        // str
        NSString *subStr = [text substringWithRange:NSMakeRange(i, 1)];
        [textArr addObject:subStr];
        // label
        UILabel *label = [self createLabel:subStr];
        CGFloat labelHeight = label.frame.size.height;
        CGFloat selfHeight = self.frame.size.height;
        label.frame = (CGRect){CGPointMake(labelArr.count?CGRectGetMaxX(labelArr.lastObject.frame):0, (labelHeight < selfHeight ? (selfHeight - labelHeight)/2: 0)),label.frame.size};
        [labelArr addObject:label];
        [self addSubview:label];
        
    }
    handler([textArr copy],[labelArr copy]);
    
    
    
}
//创建文本
- (UILabel *)createLabel:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.font = self.font;
    label.textColor = self.textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = str;
    [label sizeToFit];
    return label;
}
//动画
- (void)showScrollAnimiationWithTextArr:(NSArray <NSString *>*)textArr lableArr:(NSArray <UILabel *> *)lableArr {
    NSInteger targetLength = lableArr.count;
    NSInteger hisLength = self.labelArr.count;
    for (NSInteger i = 0; i < targetLength; i ++) {
        NSInteger targetIndex = targetLength - i - 1;
        NSInteger hisTargetIndex = hisLength - i - 1;
        if (i < hisLength) {
            if (![textArr[targetIndex] isEqualToString:self.textArr[hisTargetIndex]]) {
                BOOL increase = textArr[targetIndex].integerValue > self.textArr[hisTargetIndex].integerValue;
                // his label
                UILabel *hisLabel = self.labelArr[hisTargetIndex];
                CGRect hisTargetFrame = CGRectOffset(hisLabel.frame, 0, (increase?-1:1)*hisLabel.frame.size.height);
                // new label
                UILabel *label = lableArr[targetIndex];
                CGRect frame = label.frame;
                CGRect targetFrame = CGRectOffset(frame, 0, (increase?1:-1)*label.frame.size.height);
                label.frame = targetFrame;
                label.alpha = 0;
                [UIView animateWithDuration:self.animateDuration?self.animateDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    hisLabel.frame = hisTargetFrame;
                    label.frame = frame;
                    hisLabel.alpha = 0;
                    label.alpha = 1;
                } completion:^(BOOL finished) {
                    [hisLabel removeFromSuperview];
                }];
            }else{
                [self.labelArr[hisTargetIndex] removeFromSuperview];
            }
        }else{
            UILabel *label = lableArr[targetIndex];
            CGRect frame = label.frame;
            label.alpha = 0;
            label.frame = CGRectOffset(frame, 0, -frame.size.height);
            [UIView animateWithDuration:self.animateDuration?self.animateDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                label.frame = frame;
                label.alpha = 1;
            } completion:nil];
        }
    }
    
    if (hisLength > targetLength) {
        for (int i = 0; i < hisLength - targetLength; i ++) {
            UILabel *label = self.labelArr[i];
            CGRect hisTargetFrame = CGRectOffset(label.frame, 0, -1*label.frame.size.height);
            [UIView animateWithDuration:self.animateDuration?self.animateDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                label.frame = hisTargetFrame;
                label.alpha = 0;
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        }
    }
    self.textArr = textArr;
    self.labelArr = lableArr;
}
#pragma mark - tap
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isTapAction) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    __weak typeof(self) weakSelf = self;
    
    [self getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tapAttributeInLabel:string:range:)]) {
            [weakSelf.delegate tapAttributeInLabel:weakSelf string:string range:range];
        }
    }];
    
}
- (void)getTapFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *string , NSRange range))resultBlock {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + 20));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    CGFloat total_height =  [self textSizeWithAttributedString:self.attributedText width:self.bounds.size.width numberOfLines:0].height;
    
    if (!lines) {
        return;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGAffineTransform transform = [self transformForCoreText];
    
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        CGFloat lineOutSpace = (self.bounds.size.height - total_height) / 2;
        
        rect.origin.y = lineOutSpace + [self getLineOrign:line];
        
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat offset;
            
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }

            [self.attributedText enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, self.attributedText.string.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                if (value) {
                    if (NSLocationInRange(index, range)) {
                        if (resultBlock) {
                            resultBlock (value , range);
                        }
                    }
                }
            }];
        }
    }
}
- (CGAffineTransform)transformForCoreText {
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = 0.0f;
    
    CFRange range = CTLineGetStringRange(line);
    NSAttributedString * attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
    if ([attributedString.string hasSuffix:@"\n"] && attributedString.string.length > 1) {
        attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, attributedString.length - 1)];
    }
    height = [self textSizeWithAttributedString:attributedString width:self.bounds.size.width numberOfLines:0].height;
    return CGRectMake(point.x, point.y , width, height);
}

- (CGFloat)getLineOrign:(CTLineRef)line {
    CFRange range = CTLineGetStringRange(line);
    if (range.location == 0) {
        return 0.;
    }else {
        NSAttributedString * attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, range.location)];
        if ([attributedString.string hasSuffix:@"\n"] && attributedString.string.length > 1) {
            attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, attributedString.length - 1)];
        }
        return [self textSizeWithAttributedString:attributedString width:self.bounds.size.width numberOfLines:0].height;
    }
}
- (CGSize)textSizeWithAttributedString:(NSAttributedString *)attributedString width:(float)width numberOfLines:(NSInteger)numberOfLines {
    @autoreleasepool {
        UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        sizeLabel.numberOfLines = numberOfLines;
        sizeLabel.attributedText = attributedString;
        CGSize fitSize = [sizeLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
        return fitSize;
    }
}
#pragma mark - Lazy
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [QLBaseView new];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.canClickLower = YES;
    }
    return _backgroundView;
}


@end
