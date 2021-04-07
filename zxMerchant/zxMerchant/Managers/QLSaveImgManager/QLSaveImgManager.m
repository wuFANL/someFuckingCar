//
//  QLSaveImgManager.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/9/28.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLSaveImgManager.h"
#import <Photos/Photos.h>

@interface QLSaveImgManager()

@end
@implementation QLSaveImgManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark- action
- (void)saveImgs:(NSArray <UIImage *>*)imgsArr complete:(ResultBlock)handler {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return;
    }
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        for (UIImage *img in imgsArr) {
            //写入图片到相册
            [PHAssetChangeRequest creationRequestForAssetFromImage:img];
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        QLLog(@"success = %d, error = %@", success, error);
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(@(success),error);
        });
    }];
}
#pragma mark - Lazy
+ (QLSaveImgManager *)share {
    static QLSaveImgManager *saveImg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        saveImg = [QLSaveImgManager new];
    });
    return saveImg;
}
@end
