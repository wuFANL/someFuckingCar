//
//  QLMyCarDetailHeadView.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/14.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLMyCarDetailHeadView.h"

@interface QLMyCarDetailHeadView()<QLBaseCollectionViewDelegate>
@property (nonatomic, weak) QLBaseCollectionView *collectionView;

@end

@implementation QLMyCarDetailHeadView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [QLMyCarDetailHeadView viewFromXib];
        //collectionView
        [self addColloectionView];
    }
    return self;
}
- (void)setBannerArr:(NSArray *)bannerArr {
    _bannerArr = bannerArr;
    self.collectionView.dataArr = [bannerArr mutableCopy];
}
#pragma mark -collectionView
- (void)addColloectionView {
    QLItemModel *model = [QLItemModel new];
    model.itemSize = CGSizeMake(ScreenWidth/3.5, 80);
    model.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    model.Spacing = QLMinimumSpacingMake(0, 0);
    model.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    QLBaseCollectionView *collectionView = [[QLBaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80) ItemModel:model];
    collectionView.extendDelegate = self;
    [self insertSubview:collectionView belowSubview:self.textView];
    self.collectionView = collectionView;
}
- (void)collectionView:(UICollectionView *)collectionView Item:(UICollectionViewCell *)baseCell IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    UIImageView *imgView= [baseCell viewWithTag:indexPath.row+100];
    if (!imgView) {
         imgView = [[UIImageView alloc]init];
    }
    imgView.frame = CGRectMake(-1, 0, baseCell.width+1, baseCell.height);
    imgView.tag = indexPath.row+100;
    NSDictionary *dic = self.bannerArr[indexPath.row];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic_url"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            [imgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            imgView.contentMode =  UIViewContentModeScaleAspectFill;
            imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            imgView.clipsToBounds  = YES;
        }
    }];
    [baseCell addSubview:imgView];
}
- (void)collectionViewSelect:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath Data:(NSMutableArray *)dataArr {
    if (self.deleage&&[self.deleage respondsToSelector:@selector(selectIndex:Data:)]) {
        [self.deleage selectIndex:indexPath.row Data:dataArr];
    }
}


@end
