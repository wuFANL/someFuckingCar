//
//  QLHomeCarCell.m
//  zxMerchant
//
//  Created by lei qiao on 2020/9/30.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLHomeCarCell.h"

@implementation QLHomeCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - setter
- (void)setAccType:(AccType)accType {
    _accType = accType;
    if (accType == AccTypeNew) {
        self.accImgView.hidden = NO;
        self.activityBjView.hidden = YES;
        self.accImgView.image = [UIImage imageNamed:@"new"];
    } else if (accType == AccTypeReduction) {
        self.accImgView.hidden = YES;
        self.activityBjView.hidden = NO;
        self.activityImgView.image = [UIImage imageNamed:@"activityBj"];
    } else {
        self.accImgView.hidden = YES;
        self.activityBjView.hidden = YES;
    }
}


- (void)updateUIWithDic:(NSDictionary *)dataDic {
    NSString *carImg = [dataDic objectForKey:@"car_img"];
    if (carImg) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:carImg]];
    }
    self.titleLB.text = [dataDic objectForKey:@"model"];
    NSString *yearStr = [dataDic objectForKey:@"production_year"]?[[dataDic objectForKey:@"production_year"] stringByAppendingString:@" | "]:@"";
    NSString *disTance = [dataDic objectForKey:@"driving_distance"]?[[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"driving_distance"]] stringByAppendingString:@"万公里"]:@"";
    self.descLB.text = [yearStr stringByAppendingString:disTance];
    self.priceLB.text = [[QLToolsManager share] unitConversion:[[dataDic objectForKey:@"wholesale_price"] floatValue]];
    if ([dataDic objectForKey:@"wholesale_price_old"]) {
        self.retailPriceLB.text = [NSString stringWithFormat:@"零售价%@",[[QLToolsManager share] unitConversion:[[dataDic objectForKey:@"wholesale_price_old"] floatValue]]];
    }
    
    self.cityLabel.text = [dataDic objectForKey:@"city_belong"];
    
    //state =1最新上架 =0无标签
    NSString * state = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"state"]];
    if ([state isEqualToString:@"1"]) {
        self.accImgView.hidden = NO;
    } else {
        self.accImgView.hidden = YES;
    }
}

@end
