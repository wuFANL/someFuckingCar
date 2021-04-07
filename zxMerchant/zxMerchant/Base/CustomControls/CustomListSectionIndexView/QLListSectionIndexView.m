//
//  QLListSectionIndexView.m
//  
//
//  Created by 乔磊 on 2017/9/29.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLListSectionIndexView.h"

#define btnInterval 5
@interface QLListSectionIndexView()<UITableViewDelegate,UICollectionViewDelegate>
@property (nonatomic, weak) QLBaseButton *currentBtn;
@property (nonatomic, strong) NSMutableArray *btnArr;
@end

@implementation QLListSectionIndexView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultSet];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame IndexArray:(NSMutableArray *)indexArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.indexArr = indexArr;
        
        [self defaultSet];
       
    }
    return self;
}

- (void)layoutSubviews {
    [self.scrollView setFrame:self.bounds];
    CGFloat btnHeight = self.width-(btnInterval*2);
    self.scrollView.contentSize = CGSizeMake(self.width, self.indexArr.count*(btnHeight+btnInterval));
    for (int i = 0;i<self.btnArr.count;i++) {
        UIButton *btn = self.btnArr[i];
        btn.frame = CGRectMake((self.width-btnHeight)*0.5, i*(btnHeight+btnInterval), btnHeight, btnHeight);
    }
}
#pragma mark - setter
//设置选择下标
- (void)setSectionIndex:(NSInteger)sectionIndex {
    _sectionIndex = sectionIndex;
    if (sectionIndex >= 0) {
        QLBaseButton *btn = [self viewWithTag:sectionIndex+100];
        if(self.currentBtn != btn) {
            self.currentBtn.selected = NO;
            btn.selected = YES;
            self.currentBtn = btn;
            [self.scrollView setContentOffset:btn.origin animated:YES];
        }
    } else if (sectionIndex == -1){
        self.currentBtn.selected = NO;
        self.currentBtn = nil;
    }
}
//设置关联view
- (void)setRelevanceView:(UIView *)relevanceView {
    _relevanceView = relevanceView;
    if (relevanceView) {
        [relevanceView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}
- (void)setDefaultImg:(UIImage *)defaultImg {
    _defaultImg = defaultImg;
    for (UIButton *btn in self.btnArr) {
        [btn setBackgroundImage:defaultImg forState:UIControlStateNormal];
    }
}
- (void)setSelectImg:(UIImage *)selectImg {
    _selectImg = selectImg;
    for (UIButton *btn in self.btnArr) {
        [btn setBackgroundImage:selectImg forState:UIControlStateSelected];
    }
}
- (void)setDefaultColor:(UIColor *)defaultColor {
    _defaultColor = defaultColor;
    for (UIButton *btn in self.btnArr) {
        [btn setTitleColor:defaultColor forState:UIControlStateNormal];
    }
}
- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    for (UIButton *btn in self.btnArr) {
        [btn setTitleColor:selectColor forState:UIControlStateSelected];
    }
}
- (void)setFont:(UIFont *)font {
    _font = font;
    for (UIButton *btn in self.btnArr) {
        btn.titleLabel.font = font;
    }
}
//设置数据
- (void)setIndexArr:(NSMutableArray *)indexArr {
    _indexArr = indexArr;
    self.btnArr = nil;
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < self.indexArr.count; i++) {
        QLBaseButton *btn = [[QLBaseButton alloc]init];
        btn.light = NO;
        btn.tag = i+100;
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        if([self.indexArr[i] isEqualToString:@"搜索"]) {
            [btn setImage:self.searchImg forState:UIControlStateNormal];
        } else {
            [btn setTitle:self.indexArr[i] forState:UIControlStateNormal];
            if (self.defaultColor) {
                [btn setTitleColor:self.defaultColor forState:UIControlStateNormal];
            }
            if (self.selectColor) {
                [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
                
            }
            [btn setBackgroundImage:self.defaultImg forState:UIControlStateNormal];
            [btn setBackgroundImage:self.selectImg forState:UIControlStateSelected];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [self.btnArr addObject:btn];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
#pragma mark - action
//默认设置
- (void)defaultSet {
    self.backgroundColor = [UIColor clearColor];
    self.defaultColor = [UIColor grayColor];
    [self addSubview:self.scrollView];
}
- (void)btnClick:(QLBaseButton *)sender {
    NSInteger index = sender.tag-100;
    if(self.currentBtn != sender) {
        //选中按钮变化
        self.currentBtn.selected = NO;
        sender.selected = YES;
        self.currentBtn = sender;
        //关联view滑动
        if ([self.relevanceView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self.relevanceView;
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } else if ([self.relevanceView isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)self.relevanceView;
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
    }
    [self.delegate indexClickEvent:index];
}
//偏移监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.relevanceView) {
        UIScrollView *scrollView = object;
        CGFloat offY = scrollView.contentOffset.y;
        CGPoint point = CGPointMake(0, offY);
        NSIndexPath *ip = nil;
        if ([self.relevanceView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self.relevanceView;
            ip = [tableView indexPathForRowAtPoint:point];
        } else if ([self.relevanceView isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)self.relevanceView;
            ip = [collectionView indexPathForItemAtPoint:point];
        }
        if (self.sectionIndex != ip.section) {
            self.sectionIndex = ip.section;
        }
    }
}
- (void)dealloc {
    [self.relevanceView removeObserver:self forKeyPath:@"contentOffset"];
}
#pragma mark -懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = NO;
    }
    return _scrollView;
}
- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
