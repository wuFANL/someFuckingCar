//
//  QLVehicleCertificateCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/25.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLVehicleCertificateCell.h"
@interface QLVehicleCertificateCell()<QLHeadListViewDelegate>

@end
@implementation QLVehicleCertificateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.detailBtn roundRectCornerRadius:2 borderWidth:1 borderColor:GreenColor];
    [self.shareBtn roundRectCornerRadius:2 borderWidth:1 borderColor:ClearColor];
    //头像列表
    [self.contentView addSubview:self.hlView];
    [self.hlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailBtn);
        make.right.equalTo(self.detailBtn.mas_left).offset(-15);
        make.left.equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(35);
    }];
    
}
#pragma mark- action
- (void)setModel:(QLCarInfoModel *)model {
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.car_img]];
    self.titleLB.text = [NSString stringWithFormat:@"%@ %@ %@",model.brand,model.series,model.model];
    self.priceLB.text = [[QLToolsManager share] unitConversion:model.sell_price.floatValue];
    self.descLB.text = [NSString stringWithFormat:@"%@年|%@万公里",model.production_year,[[QLToolsManager share] unitMileage:model.driving_distance.floatValue]];
    NSMutableArray *temArr = [NSMutableArray array];
    for (QLCarBannerModel *attModel in model.att_list) {
        if ([attModel.detecte_total_name isEqualToString:@"证件照片"]) {
            [temArr addObject:attModel.pic_url];
        }
    }
    self.imgArr = temArr;
}
- (void)setImgArr:(NSArray *)imgArr {
    _imgArr = imgArr;
    self.hlView.headsArr = imgArr;
}
//设置头像列表
- (void)setItemIndex:(NSInteger)index Obj:(UIButton *)itemBtn {
    NSString *imgUrl = self.imgArr[index];
    [itemBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal];
}
//头像列表点击
- (void)clickItemIndex:(NSInteger)index Obj:(UIButton *)itemBtn {
    
}
#pragma mark- lazyLoading
- (QLHeadListView *)hlView {
    if (!_hlView) {
        _hlView = [QLHeadListView new];
        _hlView.headDelegate = self;
    }
    return _hlView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
