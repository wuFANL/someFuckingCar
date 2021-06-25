//
//  QLAddCarPageModel.h
//  zxMerchant
//
//  Created by wufan on 2021/6/25.
//  Copyright © 2021 ql. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLAddCarPageModel : NSObject
@property (nonatomic, strong ) NSString  *currentText;
@property (nonatomic, strong ) NSMutableArray  *belongArr;
@property (nonatomic, strong ) NSMutableArray  *nameArr;

- (void )queryData :(NSDictionary *)param complet:(void(^)(BOOL result))complet;

@end

NS_ASSUME_NONNULL_END
