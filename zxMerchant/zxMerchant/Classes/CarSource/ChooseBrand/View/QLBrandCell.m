//
//  QLBrandCell.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/19.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBrandCell.h"

@implementation QLBrandCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setImage_url:(NSString *)image_url {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            self.imageView.image = [UIImage drawWithImage:image size:CGSizeMake(35, 35)];
            [self layoutIfNeeded];
            [self setNeedsLayout];
        }
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
