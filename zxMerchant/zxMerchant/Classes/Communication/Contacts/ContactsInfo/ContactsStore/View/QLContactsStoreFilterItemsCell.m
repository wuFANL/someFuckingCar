//
//  QLContactsStoreFilterItemsCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/10/13.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLContactsStoreFilterItemsCell.h"


@interface QLContactsStoreFilterItemsCell()<QLBaseCollectionViewDelegate>

@end
@implementation QLContactsStoreFilterItemsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.accControl setShadowPathWith:[UIColor groupTableViewBackgroundColor] shadowOpacity:0.6 shadowRadius:1 shadowSide:QLShadowPathLeft shadowPathWidth:1];
    
    [self.contentView insertSubview:self.priceCollectionView atIndex:0];
    [self.priceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.right.equalTo(self.accControl.mas_left);
        make.height.mas_equalTo(50);
    }];
    
    [self.contentView insertSubview:self.carIconCollectionView atIndex:0];
    [self.carIconCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.right.equalTo(self.accControl.mas_left);
        make.bottom.equalTo(self.priceCollectionView.mas_top);
    }];
    self.priceCollectionView.dataArr = [@[@"不限价格",@"5万以内",@"5万-10万",@"10万-15万",@"15万-20万",@"20万-30万",@"30万-50万",@"50万以上"] mutableCopy];
}

-(IBAction)actionALlCar:(id)sender
{
    if(self.allBlock)
    {
        self.allBlock();
    }
}

#pragma mark - collectionView
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if ([baseCell isKindOfClass:[QLImgTextItem class]]) {
        QLImgTextItem *item = (QLImgTextItem *)baseCell;
        NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
        [item.imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image_url"]]];
        item.titleLB.text = [dic objectForKey:@"brand_name"];
        
    } else if ([baseCell isKindOfClass:[QLConditionsItem class]]) {
        QLConditionsItem *item = (QLConditionsItem *)baseCell;
        item.deleteBtnWidth.constant = 0;
        item.deleteLeftSpace.constant = 0;
        item.deleteBtn.hidden = YES;
        item.titleLB.text = [dataArr objectAtIndex:indexPath.row];
        [item roundRectCornerRadius:2 borderWidth:1 borderColor:[UIColor lightGrayColor]];
    }
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if(collectionView.tag == 10086)
    {
        //车标
        NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
        if(self.carBlock)
        {
            self.carBlock([dic objectForKey:@"id"]);
        }
    }
    else
    {
        //价格
        NSString *price = [dataArr objectAtIndex:indexPath.row];
        if(self.carPriceBlock)
        {
            self.carPriceBlock(price);
        }
    }
}
#pragma mark - Lazy
- (QLBaseCollectionView *)carIconCollectionView {
    if(!_carIconCollectionView) {
        QLItemModel *model = [QLItemModel new];
        model.rowCount = 1;
        model.columnCount = 5;
        model.sectionInset = UIEdgeInsetsMake(20, 15, 13, 10);
        model.Spacing = QLMinimumSpacingMake(20, 20);
        model.registerType = CellNibRegisterType;
        model.itemName = @"QLImgTextItem";
        model.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _carIconCollectionView = [[QLBaseCollectionView alloc] initWithSize:CGSizeMake(ScreenWidth, 90) ItemModel:model];
        _carIconCollectionView.extendDelegate = self;
        
    }
    _carIconCollectionView.tag = 10086;
    return _carIconCollectionView;
}
- (QLBaseCollectionView *)priceCollectionView {
    if(!_priceCollectionView) {
        QLItemModel *model = [QLItemModel new];
        model.rowCount = 1;
        model.columnCount = 3.6;
        model.sectionInset = UIEdgeInsetsMake(5, 15, 20, 15);
        model.Spacing = QLMinimumSpacingMake(15, 15);
        model.registerType = CellNibRegisterType;
        model.itemName = @"QLConditionsItem";
        model.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _priceCollectionView = [[QLBaseCollectionView alloc] initWithSize:CGSizeMake(ScreenWidth, 50) ItemModel:model];
        _priceCollectionView.extendDelegate = self;
        
    }
    _carIconCollectionView.tag = 10087;
    return _priceCollectionView;
}
@end
