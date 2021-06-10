//
//  QLChatBottomView.m
//  zxMerchant
//
//  Created by lei qiao on 2020/11/9.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLChatBottomView.h"
#import "QLImgTextItem.h"

@interface QLChatBottomView()<QLBaseCollectionViewDelegate>
@property (nonatomic, strong) QLBaseCollectionView *collectionView;

@end
@implementation QLChatBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLChatBottomView viewFromXib];
    }
    return self;
}
#pragma mark - setter
- (void)setFunArr:(NSArray *)funArr {
    _funArr = funArr;
    
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
    
    QLItemModel *model = [QLItemModel new];
    model.rowCount = 1;
    model.columnCount = self.funArr.count;
    model.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    model.sectionInset = UIEdgeInsetsMake(10, 5, 5, 5);
    model.Spacing = QLMinimumSpacingMake(0, 0);
    model.itemName = @"QLImgTextItem";
    self.collectionView = [[QLBaseCollectionView alloc] initWithFrame:self.funView.frame ItemModel:model];
    self.collectionView.extendDelegate = self;
    self.collectionView.dataArr = [self.funArr mutableCopy];
    [self.funView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.funView);
    }];
}
#pragma mark - collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLImgTextItem class]]) {
        QLImgTextItem *item = (QLImgTextItem *)baseCell;
        
        NSString *title = self.funArr[indexPath.row];
        item.titleLB.textColor = [UIColor colorWithHexString:@"#999999"];
        item.titleLB.text = title;
        
        NSString *imgName;
        if ([title isEqualToString:@"交易"]) {
            imgName = @"jiaoyiIcon";
        } else if ([title isEqualToString:@"图片"]) {
            imgName = @"tupianIcon";
        } else if ([title isEqualToString:@"车证"]) {
            imgName = @"chezhenIcon";
        } else if ([title isEqualToString:@"派单"]) {
            imgName = @"chatOrder";
        } else if ([title isEqualToString:@"联系"]) {
            imgName = @"lianxiIcon";
        } else if ([title isEqualToString:@"加入帮卖"]) {
            imgName = @"bangmaiIcon";
        } else if ([title isEqualToString:@"取消帮卖"]) {
            imgName = @"quxiaoIcon";
        }
        
        item.imgView.image = [UIImage imageNamed:imgName];
        
    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if (self.clickHandler) {
        NSString *title = self.funArr[indexPath.row];
        self.clickHandler(title, nil);
    }
}

-(IBAction)sendMsg
{
    if(self.msgBlock && self.tv.text.length > 0)
    {
        self.msgBlock(self.tv.text);
        self.tv.text = @"";
    }
}

@end
