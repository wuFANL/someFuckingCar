//
//  QLVehicleConditionsView.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/9.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLVehicleConditionsView.h"
#import "QLIconItem.h"
#import "QLVehicleWarnItem.h"

@interface QLVehicleConditionsView()<QLBaseViewDelegate,QLBaseCollectionViewDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) QLBaseView *alertView;
@property (nonatomic, strong) QLBaseCollectionView *collectionView;
@property (nonatomic, strong) QLBaseCollectionView *warnCollectionView;
@property (nonatomic, strong) QLBaseView *lineView;
@property (nonatomic, strong) QLBaseButton *closeBtn;

@end
@implementation QLVehicleConditionsView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        self.viewDelegate = self;
        self.sort_by = 1;
        self.priceRange = @"0-9999999";

    }
    return self;
}
#pragma mark -action
//设置偏移量
- (void)setOffY:(CGFloat)offY {
    _offY = offY;
    //新增window
    CGFloat top = BottomOffset?88:64;
    self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0, top+self.offY, ScreenWidth, ScreenHeight-top-self.offY)];
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.hidden = YES;
    [KeyWindow addSubview:self.window];
    [self.window makeKeyAndVisible];
    //设置控件大小
    self.frame = self.window.bounds;
    //加载子控件
    [self addSubviews];
}
//选择显示类型
- (void)setType:(NSInteger)type {
    _type = type;
    self.lineView.hidden = YES;
    NSArray *conditions = nil;
    NSArray *warns = nil;
    if (type == 0) {
        //智能排序
        conditions = @[@"智能排序",@"价格最低",@"价格最高",@"车龄最短",@"里程最少"];
        
    } else if (type == 1) {
        //价格
        conditions = @[@"不限价格",@"5万以内",@"5万-10万",@"10万-15万",@"15万-20万",@"20万-30万",@"30万-50万",@"50万以上"];

    } else if (type == 2) {
        //状态
        conditions = @[@"在售",@"仓库中",@"已售"];
        warns = @[@"年检到期",@"强制险到期"];
//        warns = @[@"年检到期",@"强制险到期",@"库龄超期"];
        self.lineView.hidden = NO;
    } else if (type == 3) {
     //选择车辆筛选
        conditions = @[@"不限价格",@"5万以内",@"5万-10万",@"10万-15万",@"15万-20万",@"20万以上"];
    } else if (type == 4) {
        conditions = @[@"全部",@"待提交",@"已提交",@"通过",@"驳回"];
    }
    NSInteger row = ceil(conditions.count/3.0);
    CGFloat collectionViewHeight = (50*row+(row+1)*15);
    CGFloat alertViewHieght = collectionViewHeight+50+(type==2?140:0);
    
    [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(alertViewHieght);
    }];
    self.warnCollectionView.dataArr = [warns mutableCopy];
    self.collectionView.dataArr = [conditions mutableCopy];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(collectionViewHeight);
    }];
}
//设置点中下标
- (void)setSelectIndexPath:(NSIndexPath *)selectIndexPath {
    _selectIndexPath = selectIndexPath;
    if ([self.collectionView cellForItemAtIndexPath:selectIndexPath] != nil) {
        [self.collectionView reloadData];
    }
    if ([self.warnCollectionView cellForItemAtIndexPath:selectIndexPath] != nil) {
        [self.warnCollectionView reloadData];
    }
    
}
//数据设置
- (void)setWarnModel:(QLVehicleWarnModel *)warnModel {
    _warnModel = warnModel;
    [self.collectionView reloadData];
    [self.warnCollectionView reloadData];
}
//加载子控件
- (void)addSubviews {
    //背景
    [self addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    //关闭按钮
    [self.alertView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.height.mas_equalTo(15);
        make.bottom.equalTo(self.alertView).offset(-20);
    }];
    //类型选择
    [self.alertView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.alertView);
        make.height.mas_equalTo(0);
    }];
    //分割线
    [self.alertView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.collectionView.mas_bottom).offset(10);
        make.left.equalTo(self.alertView).offset(15);
        make.right.equalTo(self.alertView).offset(-15);
        make.height.mas_equalTo(1);
    }];
    //警告选择
    [self.alertView addSubview:self.warnCollectionView];
    [self.warnCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.alertView);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.closeBtn.mas_top);
        
    }];
    
}
//关闭按钮
- (void)closeBtnClick {
    [self hidden];
}
//显示
- (void)show {
    [self setType:self.type];
    self.window.hidden = NO;
    [self.window addSubview:self];
    
}
//隐藏
- (void)hidden {
    [UIView animateWithDuration:animationDuration animations:^{
        [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35);
        }];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.handler) {
            self.handler(self.selectIndexPath);
        }
        [self removeFromSuperview];
        self.window.hidden = YES;
    }];
}
//遮罩点击
- (void)hiddenViewEvent {
    [self hidden];
}
#pragma mark -collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLIconItem class]]) {
        QLIconItem *item = (QLIconItem *)baseCell;
        item.iconBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [item.iconBtn setTitle:dataArr[indexPath.row] forState:UIControlStateNormal];
        UIColor *color  = nil;
        if (self.selectIndexPath == indexPath) {
            color = GreenColor;
            item.iconBtn.selected = YES;
        } else {
            color = [UIColor lightGrayColor];
            item.iconBtn.selected = NO;
        }
        [item.iconBtn setTitleColor:color forState:UIControlStateNormal];
        [item roundRectCornerRadius:3 borderWidth:1 borderColor:color];
    } else if ([baseCell isKindOfClass:[QLVehicleWarnItem class]]) {
        QLVehicleWarnItem *item = (QLVehicleWarnItem *)baseCell;
        item.titleLB.text = dataArr[indexPath.row];
        NSString *numStr = indexPath.row==0?self.warnModel.mot_warn:indexPath.row==1?self.warnModel.insure_warn:self.warnModel.assets_warn;
        item.numLB.text = numStr.length==0?@"0":numStr;
        [item roundRectCornerRadius:3 borderWidth:1 borderColor:[UIColor groupTableViewBackgroundColor]];
    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if (collectionView.tag == 0) {
        self.selectIndexPath = indexPath;
        [collectionView reloadData];
    } else {
        NSIndexPath *ip = [NSIndexPath indexPathForItem:indexPath.row inSection:1];
        self.selectIndexPath = ip;
    }
    [self hidden];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewKind:(NSString *)kind IndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader&&collectionView.tag == 1) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        UILabel *lb = [UILabel new];
        lb.text = @"库存预警";
        lb.font = [UIFont systemFontOfSize:15];
        [header addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).offset(15);
            make.centerY.equalTo(header);
        }];
        return header;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout viewKind:(NSString *)kind InSection:(NSInteger)section {
    if (collectionView.tag == 1&&kind == UICollectionElementKindSectionHeader) {
        return CGSizeMake(self.width, 40);
    }
    return CGSizeZero;
}
#pragma mark - Lazy
- (QLBaseView *)alertView {
    if (!_alertView) {
        _alertView = [QLBaseView new];
        _alertView.backgroundColor = WhiteColor;
    }
    return _alertView;
}
- (QLBaseCollectionView *)collectionView {
    if (!_collectionView) {
        QLItemModel *model = [QLItemModel new];
        model.columnCount = 3;
        model.itemSize = CGSizeMake((self.width-15*4)/3, 50);
        model.itemName = @"QLIconItem";
        model.Spacing = QLMinimumSpacingMake(15, 15);
        model.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectZero ItemModel:model];
        _collectionView.extendDelegate = self;
        _collectionView.tag = 0;
    }
    return _collectionView;
}
- (QLBaseCollectionView *)warnCollectionView {
    if (!_warnCollectionView) {
        QLItemModel *model = [QLItemModel new];
        model.columnCount = 3;
        model.itemSize = CGSizeMake((self.width-15*4)/3, 75);
        model.itemName = @"QLVehicleWarnItem";
        model.Spacing = QLMinimumSpacingMake(15, 15);
        model.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _warnCollectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectZero ItemModel:model];
        _warnCollectionView.extendDelegate = self;
        _warnCollectionView.tag = 1;
        [_warnCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _warnCollectionView;
}
- (QLBaseView *)lineView {
    if (!_lineView) {
        _lineView = [QLBaseView new];
        _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _lineView.hidden = YES;
    }
    return _lineView;
}
- (QLBaseButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [QLBaseButton new];
        [_closeBtn setImage:[UIImage imageNamed:@"closeUp"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end