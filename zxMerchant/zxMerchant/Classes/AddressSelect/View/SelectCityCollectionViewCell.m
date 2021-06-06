//
//  SelectCityCollectionViewCell.m
//  zxMerchant
//
//  Created by 张精申 on 2021/6/5.
//  Copyright © 2021 ql. All rights reserved.
//

#import "SelectCityCollectionViewCell.h"

@implementation SelectCityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 95, 40)];
        self.titleLabel.backgroundColor = [UIColor colorWithRed:209/255.0 green:239/255.0 blue:216/255.0 alpha:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithRed:90/255.0 green:191/255.0 blue:112/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

+ (CGSize)selfSize {
    return CGSizeMake(95, 40);
}

@end
