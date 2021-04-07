//
//  QLUserInfoModel.m
//  JSTY
//
//  Created by 乔磊 on 2018/5/21.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLUserInfoModel.h"

@implementation QLUserInfoModel
//是否登录
- (BOOL)isLogin {
    if (self.account.account_id.length != 0) {
        return YES;
    }
    return NO;
}
//是否是内部账号
- (BOOL)isTest {
    if ([self.account.mobile isEqualToString:@"18136249206"]||self.account.account_id.length == 0||self.account == nil) {
        return YES;
    }
    return NO;
}
//保存本地信息
+ (void)saveUserInfo:(NSDictionary *)result_info {
    [UserDefaults setObject:result_info forKey:LocalUserInfoKey];
}
//获取本地用户信息字典
+ (NSDictionary *)getLocalDic {
    NSDictionary *userInfo = [UserDefaults objectForKey:LocalUserInfoKey];
    return userInfo;
}
//获取本地用户信息
+ (QLUserInfoModel *)getLocalInfo {
    NSDictionary *userInfo = [QLUserInfoModel getLocalDic];
    QLUserInfoModel *userInfoModel = [QLUserInfoModel yy_modelWithJSON:userInfo];
    return userInfoModel;
}
//修改本地用户信息参数
+ (void)updateUserInfoByModel:(QLUserInfoModel *)userInfo {
    NSDictionary *user_info = [userInfo yy_modelToJSONObject];
    QLLog(@"%@",user_info);
    [QLUserInfoModel saveUserInfo:user_info];

}
//退出登录
+ (void)loginOut {
    [UserDefaults setObject:nil forKey:LocalUserInfoKey];
}
//自定义解析
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"account"  : @[@"account",@"m_account"],
             @"business"  : @[@"business",@"m_business"],
             @"personnel"  : @[@"personnel",@"m_personnel"],
            };
}
@end

@implementation QLUserModel

@end

@implementation QLBusinessModel
//详细地址
- (NSString *)detailAddress {
    if (!_detailAddress) {
        _detailAddress = [NSString stringWithFormat:@"%@%@%@%@",QLNONull(self.province),QLNONull(self.city),QLNONull(self.business_area),QLNONull(self.address)];
    }
    return _detailAddress;
}
@end

@implementation QLPersonnelModel
- (QLRoleModel *)role {
    if (!_role) {
        _role = self.role_date.firstObject;
    }
    return _role;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
                @"role_date" : [QLRoleModel class],
            };
}
@end

@implementation QLRoleModel


@end

@implementation QLAccountModel
//自定义解析
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"id"  : @"member_account_id",
            };
}

@end
