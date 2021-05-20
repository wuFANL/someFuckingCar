//
//  QLHomePageModel.m
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/6/28.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLHomePageModel.h"

@implementation QLHomePageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"banner_list" : [QLBannerModel class],
             @"function_list" : [QLFunModel class]
             };
}
- (QLFunModel *)getFun:(FunctionType)fun_value {
    for (QLFunModel *funModel in self.function_list) {
        if ([funModel.value integerValue] == fun_value) {
            return funModel;
        }
    }
    return nil;
}

- (NSDictionary *)getFunNameAndImgName:(FunctionType)fun_value {
    QLFunModel *model= [self getFun:fun_value];
    NSString *title = model.extend_01.length==0?@"":model.extend_01;
    NSString *imgName = model.diction_id.length==0?@"":model.diction_id;
    
    return @{@"funName":title,@"imgName":imgName};
}

- (NSArray *)friendCycle {
    if (!_friendCycle) {
        _friendCycle = [NSArray array];
    }
    return _friendCycle;
}
@end

@implementation QLBannerModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"banner_id"  : @"id",
            };
}
@end

@implementation QLFunModel


@end

