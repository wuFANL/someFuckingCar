//
//  QLChooseHeadView.m
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/3/19.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLChooseHeadView.h"

@interface QLChooseHeadView()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *temArr;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, weak) UIButton *currentBtn;
@end
@implementation QLChooseHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initComment];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self initComment];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.showBottomShadow) {
        [self setShadowPathWith:[UIColor groupTableViewBackgroundColor] shadowOpacity:1 shadowRadius:0 shadowSide:QLShadowPathBottom shadowPathWidth:1];
    }
    
    [self.maskView setShadowPathWith:[UIColor groupTableViewBackgroundColor] shadowOpacity:0.6 shadowRadius:0 shadowSide:QLShadowPathLeft shadowPathWidth:2];
    
    CGFloat btnWidth = self.width/(self.column==0?4:self.column);
    [self.scrollView setContentSize:CGSizeMake(btnWidth*self.temArr.count, self.height)];
    self.scrollView.frame = CGRectMake(0, 0, self.width, self.height);
    for (int i = 0;i<self.btnArr.count;i++) {
        UIButton *btn = self.btnArr[i];
        btn.frame = CGRectMake(btnWidth*i, 0, btnWidth, self.scrollView.height);
        //设置按钮样式回调
        if ([self.typeDelegate respondsToSelector:@selector(chooseTitleStyle:Index:)]) {
            [self.typeDelegate chooseTitleStyle:btn Index:i];
        }
        if (self.currentBtn == btn) {
            if ([self.typeDelegate respondsToSelector:@selector(chooseSelect:CurrentBtn:Index:)]) {
                [self.typeDelegate chooseSelect:nil CurrentBtn:self.currentBtn Index:i];
            }
        }
    }
    
    self.lineView.size = CGSizeMake(self.lineWidth, 3);
    CGFloat centerY = self.lineView.size.height*0.5;
    [self.lineView roundRectCornerRadius:centerY borderWidth:1 borderColor:ClearColor];
    self.lineView.center = CGPointMake(self.currentBtn.centerX, self.height-centerY);
}
#pragma mark - setter
//设置点中下标
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    UIButton *btn = [self viewWithTag:100+selectedIndex];
    [self typeBtnClick:btn];
    if (self.showRightMask&&selectedIndex==self.temArr.count-2) {
        [self.scrollView scrollRectToVisible:CGRectMake(btn.origin.x+btn.width, btn.origin.y, btn.width, btn.height) animated:YES];
    } else {
        [self.scrollView scrollRectToVisible:btn.frame animated:YES];
    }
    
}
//设置标题文本
- (void)setTypeArr:(NSArray *)typeArr {
    _typeArr = typeArr;
    
    //删除之前按钮
    for (UIButton *btn in self.btnArr) {
        [btn removeFromSuperview];
    }
    [self.btnArr removeAllObjects];
    //数据处理
    self.temArr = [typeArr mutableCopy];
    if (![self.temArr containsObject:@""]&&self.showRightMask) {
        [self.temArr addObject:@""];
    }
    if (typeArr.count > 0) {
        //显示下划线
        self.lineView.hidden = !self.showLineView;
        //添加新的按钮
        for (int i = 0;i<self.temArr.count;i++) {
            NSString *title = self.temArr[i];
            QLBaseButton *btn = [QLBaseButton new];
            btn.tag = 100+i;
            btn.enabled = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
            [btn setTitleColor:BlackColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                btn.selected = YES;
                self.currentBtn = btn;
            } else if (title.length == 0) {
                btn.enabled = NO;
            }
            
            [self.scrollView addSubview:btn];
            [self.btnArr addObject:btn];
        }
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}
//设置是否显示下划线
- (void)setShowLineView:(BOOL)showLineView {
    _showLineView = showLineView;
    if (showLineView) {
        self.lineView.hidden = NO;
    } else {
        self.lineView.hidden = YES;
    }
}
//设置下划线颜色
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    if (lineColor) {
        self.lineView.backgroundColor = self.lineColor;
    }
}
//设置下划线长度
- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self layoutIfNeeded];
    [self setNeedsLayout];
}
//设置是否显示右遮挡
- (void)setShowRightMask:(BOOL)showRightMask {
    _showRightMask = showRightMask;
    if (showRightMask) {
        UIImageView *maskImgView = [[UIImageView alloc]initWithImage:[UIImage createImageWithColor:[UIColor whiteColor]]];
        maskImgView.userInteractionEnabled = YES;
        maskImgView.tag = 1;
        [maskImgView setShadowPathWith:[UIColor groupTableViewBackgroundColor] shadowOpacity:0.8 shadowRadius:1 shadowSide:QLShadowPathLeft shadowPathWidth:1];
        [self addSubview:maskImgView];
        self.maskView = maskImgView;
        [maskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.width.mas_equalTo(46);
        }];
        if (showRightMask) {
            self.typeArr = self.temArr;
        }
    } else {
        [[self viewWithTag:1] removeFromSuperview];
    }
}
#pragma mark -action
//按钮点击
- (void)typeBtnClick:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    if (sender.currentTitle.length != 0) {
        if (self.typeDelegate &&[self.typeDelegate respondsToSelector:@selector(chooseSelect:CurrentBtn:Index:)]) {
            [self.typeDelegate chooseSelect:self.currentBtn CurrentBtn:sender Index:index];
        }
        
        if (self.currentBtn != sender) {
            sender.selected = YES;
            self.currentBtn.selected = NO;
            self.currentBtn = sender;
            
            self.selectedIndex = index;
            
            [UIView animateWithDuration:animationDuration animations:^{
                self.lineView.centerX = sender.centerX;
                [self layoutIfNeeded];
            }];
        }
    }
}
//常规设置
- (void)initComment {
    self.backgroundColor = WhiteColor;
    self.selectColor = GreenColor;
    self.showLineView = YES;
    //增加scrollView
    [self addSubview:self.scrollView];
    //增加下划线
    [self.scrollView addSubview:self.lineView];
    //默认设置
    self.showRightMask = NO;
    self.lineWidth = 45;
}
#pragma mark -懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = self.selectColor;
    }
    return _lineView;
}
- (NSMutableArray *)temArr {
    if (!_temArr) {
        _temArr = [NSMutableArray array];
    }
    return _temArr;
}
- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

@end
