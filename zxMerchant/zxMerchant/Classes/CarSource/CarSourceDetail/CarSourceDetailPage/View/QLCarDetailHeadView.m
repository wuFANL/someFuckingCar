//
//  QLCarDetailHeadView.m
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/4/24.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLCarDetailHeadView.h"
#import "QLBannerView.h"

@interface QLCarDetailHeadView()<QLBannerViewDelegate>
@property (nonatomic, strong) QLBannerView *bannerView;
@property (nonatomic, strong) NSString *currentPage;

@end
@implementation QLCarDetailHeadView
- (instancetype)init {
    self = [super init];
    if (self) {
        self = [QLCarDetailHeadView viewFromXib];
        
        [self.headBtn roundRectCornerRadius:35*0.5 borderWidth:1 borderColor:ClearColor];
    }
    return self;
}
#pragma mark - setter
- (void)setBannerArr:(NSArray *)bannerArr {
    _bannerArr = bannerArr;
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
    self.bannerView = [[QLBannerView alloc]initWithFrame:self.bounds HavePageControl:NO Delegate:self];
    if (bannerArr.count != 0) {
        self.bannerView.imagesArr = bannerArr;
    } else {
        self.bannerView.imagesArr = @[[UIImage imageNamed:@"reservedPictures"]];
    }
    self.bannerView.delegate = self;
    [self insertSubview:self.bannerView atIndex:0];
}
#pragma mark - bannerView
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn {
    if (self.bannerView == bannerView) {
        if (self.bannerArr.count == 0) {
            [imageBtn setBackgroundImage:imageArr[0] forState:UIControlStateNormal];
        } else {
            NSDictionary *obj = imageArr[index];
            if ([obj isKindOfClass:[NSDictionary class]] && [[obj objectForKey:@"pic_url"] isKindOfClass:[NSString class]]) {
                [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[obj objectForKey:@"pic_url"]] forState:UIControlStateNormal];
            } else if ([obj isKindOfClass:[NSString class]]) {
                [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:(NSString *)obj] forState:UIControlStateNormal];
            }
            else {
                [imageBtn setBackgroundImage:[obj objectForKey:@"pic_url"] forState:UIControlStateNormal];
            }
        }
    }

}
- (void)bannerView:(QLBannerView *)bannerView ImageData:(NSArray *)imageArr CurrentPage:(NSInteger)currentPage {
    if (self.bannerView == bannerView) {
        if (currentPage != self.currentPage.integerValue||self.currentPage.length==0) {
            self.progressLB.text = [NSString stringWithFormat:@"%ld/%ld",(long)(currentPage+1),(long)imageArr.count];
            self.currentPage = [NSString stringWithFormat:@"%ld",(long)currentPage];
        }
    }
}
- (void)bannerView:(QLBannerView *)bannerView ImageClick:(NSArray *)imageArr Index:(NSInteger)index ImageBtn:(UIButton *)imageBtn {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(bannerView:ImageData:Index:)]) {
        [self.delegate bannerView:bannerView ImageData:imageArr Index:index];
    }
}

@end
