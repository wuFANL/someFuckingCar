//
//  QLToolsManager.m
//  QLKit
//
//  Created by 乔磊 on 2018/3/21.
//  Copyright © 2018年 NineZero. All rights reserved.
//

#import "QLToolsManager.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "QLWebViewController.h"
#import "QLLoginViewController.h"
//#import "QLMsgDetailViewController.h"
//#import "QLVehicleCarDetailViewController.h"
//#import "QLCreditResultViewController.h"
//#import "QLResultDetailViewController.h"
//#import "QLUseApplyViewController.h"
//#import "QLRepayApplyViewController.h"
//#import "QLLoanDetailViewController.h"
//#import "QLBalanceWithdrawalViewController.h"
//#import "QLBalanceRechargeViewController.h"
//#import "QLCustomerDetailViewController.h"
//#import "QLAccountModel.h"

@interface QLToolsManager()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/**
 *验证码倒计时时间
 */
@property (nonatomic, assign) int tempCodeTime;
/**
 *图片结果返回
 */
@property (nonatomic, strong) ImgCallBlock imgCallBack;
@end
NSString* EncodeStringFromDic(NSDictionary *dic, NSString *key)
{
    if (nil != dic
        && [dic isKindOfClass:[NSDictionary class]]) {
        
        id temp = [dic objectForKey:key];
        if ([temp isKindOfClass:[NSString class]])
        {
            return temp;
        }
        else if ([temp isKindOfClass:[NSNumber class]])
        {
            return [temp stringValue];
        }
    }
    
    return @"";
}
NSString* Operation_type = @"operation_type";
@implementation QLToolsManager
#pragma mark- 全局数据
#pragma mark -分享记录
- (void)shareRecord:(NSDictionary *)param handler:(ResultBlock)result {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    dic[@"operation_type"] = @"do_share";
    dic[@"account_id"] = [QLUserInfoModel getLocalInfo].account.account_id;
    [QLNetworkingManager postWithParams:dic success:^(id response) {
        result(response,nil);
    } fail:^(NSError *error) {
        result(nil,error);
    }];
}
#pragma mark -业务员名下车商
- (void)getDealers:(ResultBlock)result {
    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_merchant_list_with_staff",@"staff_id":[QLUserInfoModel getLocalInfo].personnel.personnel_id} success:^(id response) {
        result(response,nil);
    } fail:^(NSError *error) {
        result(nil,error);
    }];
}
#pragma mark -申请车资出入库
- (void)applyAssetsStore:(NSDictionary *)param handler:(ResultBlock)result {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    dic[@"operation_type"] = @"apply_assets_store";
    [QLNetworkingManager postWithUrl:AssetsPath params:dic success:^(id response) {
        result(response,nil);
    } fail:^(NSError *error) {
        result(nil,error);
    }];
}
#pragma mark -取消车资出入库
- (void)cancelAssetsStore:(NSDictionary *)param handler:(ResultBlock)result {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    dic[@"operation_type"] = @"cancel_assets_store_order";
    [QLNetworkingManager postWithUrl:AssetsPath params:dic success:^(id response) {
        result(response,nil);
    } fail:^(NSError *error) {
        result(nil,error);
    }];
}
#pragma mark -首页数据
- (void)getFunData:(ResultBlock)result {
    if ([QLUserInfoModel getLocalInfo].isLogin == NO) {
        return;
    }
    [QLNetworkingManager postWithUrl:HomePath params:@{@"operation_type":@"index",@"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id)} success:^(id response) {
        self.homePageModel = [QLHomePageModel yy_modelWithJSON:response[@"result_info"]];
        result(self.homePageModel,nil);
    } fail:^(NSError *error) {
        result(nil,error);
    }];
}
#pragma mark -获取验证码
- (void)getCodeByMobile:(NSString *)mobile handler:(ResultBlock)result {
    if (mobile) {
        [QLNetworkingManager postWithParams:@{@"operation_type":@"send_verification_code",@"mobile":mobile} success:^(id response) {
            result(response,nil);
        } fail:^(NSError *error) {
            result(nil,error);
        }];
    } else {
         result(nil,[NSError errorWithDomain:@"请输入手机号" code:-1 userInfo:nil]);
    }
}
#pragma mark -客服电话
- (void)getMeInfoRequest:(ResultBlock)result {
    if ([QLUserInfoModel getLocalInfo].isLogin == NO) {
        return;
    }
    [QLNetworkingManager postWithUrl:UserPath params:@{@"operation_type":@"info",@"account_id":QLNONull([QLUserInfoModel getLocalInfo].account.account_id),@"business_id":QLNONull([QLUserInfoModel getLocalInfo].business.business_id)} success:^(id response) {
        QLUserInfoModel *meModel = [QLUserInfoModel yy_modelWithJSON:response[@"result_info"]];
        //更新本地数据
        QLUserInfoModel *userInfo = [QLUserInfoModel getLocalInfo];
        userInfo.account = meModel.account;
        userInfo.business = meModel.business;
        [QLUserInfoModel updateUserInfoByModel:userInfo];
        result(userInfo,nil);
    } fail:^(NSError *error) {
        result(nil,error);
    }];
}

#pragma mark- 全局方法
#pragma mark - 利息/返点计算
+ (NSMutableDictionary *)rateConversion:(NSString *)value {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *aStr = @"";
    NSString *bStr = @"";
    NSString *cStr = @"";
    NSString *rate = [NSString stringWithFormat:@"%@",@([value floatValue]*100)];
    NSArray *rateArr = [rate componentsSeparatedByString:@"."];
    if (rateArr.count >= 1) {
        aStr = rateArr[0];
        if (rateArr.count > 1) {
            NSString *temTate = rateArr[1];
            bStr = [temTate substringToIndex:1];
            cStr = [temTate substringFromIndex:1];
        }
    }
    param[@"a"] = aStr;
    param[@"b"] = bStr;
    param[@"c"] = cStr;
    return param;
}
+ (NSMutableDictionary *)rebateConversion:(NSString *)value {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *aStr = @"";
    NSString *bStr = @"";
    NSString *rebate = [NSString stringWithFormat:@"%@",@([value floatValue]*100)];
    NSArray *rateArr = [rebate componentsSeparatedByString:@"."];
    if (rateArr.count >= 1) {
        aStr = rateArr[0];
        if (rateArr.count >= 2) {
            bStr = rateArr[1];
        }
    }
    param[@"a"] = aStr;
    param[@"b"] = bStr;
    return param;
}
#pragma mark -自定义弹框
- (QLCustomAlertView *)alert:(NSString *)title handler:(void(^)(NSError *error))handler {
    QLCustomAlertView *alert =[[QLCustomAlertView alloc]init];
    alert.title = title;
    alert.result = ^(id result, NSError *error) {
        handler(error);
    };
    [alert show];
    return alert;
}
#pragma mark -消息详情跳转
- (void)msgDetailJump:(QLPushMsgModel *)param deleate:(UIViewController *)vc {
    if ([QLUserInfoModel getLocalInfo].isLogin) {
        //角标置空
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService setBadge:0];
        //跳转参数
        NSMutableDictionary *jumpDic = [NSMutableDictionary dictionary];
        if (param.params.length != 0) {
            NSArray *jumpArr = [param.params componentsSeparatedByString:@"&"];
            for (NSString *value in jumpArr) {
                if (value.length!= 0&&[value containsString:@"="]) {
                    NSArray *paramArr = [value componentsSeparatedByString:@"="];
                    if (paramArr.count == 2) {
                        jumpDic[paramArr[0]] = paramArr[1];
                    }
                }
            }
        }
        //消息已读
        NSString *msg_id = param.msg_id.length==0?jumpDic[@"msg_id"]:param.msg_id;
        [QLNetworkingManager postWithParams:@{@"operation_type":@"get_msg_info",@"msg_id":QLNONull(msg_id),@"user_type":@"3"} success:^(id response) {
        } fail:^(NSError *error) {
        }];
        //跳转
//        NSInteger type = param.jump_type.integerValue;

        
        
    } else {
        //去登录
        [AppDelegateShare initLoginVC];
    }
    
    
}
#pragma mark -选择图片方法
- (void)getPhotoAlbum:(UIViewController *)currentVC resultBack:(ImgCallBlock)block {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted
        || authStatus == AVAuthorizationStatusDenied) {
        [UIAlertController showAlertController:UIAlertControllerStyleAlert Title:@"摄像头已被禁用" DetailTitle:@"您可在设置应用程序中进行开启" DefaultTitle:nil CancelTitle:@"取消" Delegate:KeyWindow.rootViewController DefaultAction:^(NSString *selectedTitle) {
            
        } CancelAction:^{
            
        }];
        return ;
    }
    [UIAlertController showAlertController:UIAlertControllerStyleActionSheet Title:nil DetailTitle:nil DefaultTitle:@[@"相册",@"相机"] CancelTitle:@"取消" Delegate:currentVC DefaultAction:^(NSString *selectedTitle) {
        NSInteger type = 0;
        if ([selectedTitle isEqualToString:@"相册"]) {
            type = 0;
        } else {
            type = 1;
        }
        [self openImagePickerByType:type currentVC:currentVC resultBack:^(UIImagePickerController *picker, NSDictionary *info) {
            block(picker,info);
        }];
        
    } CancelAction:^{
        
    }];
}
- (void)openImagePickerByType:(NSInteger)type currentVC:(UIViewController *)vc resultBack:(ImgCallBlock)block {
    self.imgCallBack = block;
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc]init];
    if (type == 0) {
        //相册
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //相机
            pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            //相册
            pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    pickerVC.allowsEditing = NO;
    pickerVC.delegate  = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:pickerVC animated:YES completion:nil];
    });
    
}
//获取到图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.imgCallBack(picker, info);
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
#pragma mark -单位换算
//里程换算
- (NSString *)unitMileage:(float)digital {
    return [NSString stringWithFormat:@"%@",[NSString formatFloat:(digital/10000.00)]];
}
//价格换算
- (NSString *)unitConversion:(float)digital {
    NSString *price = [NSString formatFloat:(digital/10000.00)];
    return [NSString stringWithFormat:@"%@%@",digital>=10000.00?@(price.floatValue):@(digital),digital>=10000.00?@"万元":@"元"];
}
#pragma mark -推出web控制器
- (void)loadUrlInVC:(NSString *)loadUrl title:(NSString *)title currentVC:(UIViewController *)currentSelf {
    QLWebViewController *webVC = [QLWebViewController new];
    webVC.loadURLStr = loadUrl;
    webVC.titleStr = title;
    [currentSelf.navigationController pushViewController:webVC animated:YES];
    
}
#pragma mark- 未登录提示框
- (void)noLoginAlert:(UIViewController *)currentSelf {
    [UIAlertController showAlertController:UIAlertControllerStyleAlert Title:@"请先登录" DetailTitle:nil DefaultTitle:@[@"去登录"] CancelTitle:@"取消" Delegate:nil DefaultAction:^(NSString *selectedTitle) {
        if ([selectedTitle isEqualToString:@"去登录"]) {
            QLLoginViewController *loginVC = [QLLoginViewController new];
            QLNavigationController *navi = [[QLNavigationController alloc]initWithRootViewController:loginVC];
            [currentSelf presentViewController:navi animated:YES completion:nil];
        }
    } CancelAction:^{
        
    }];
}
#pragma mark- 联系客服
- (void)contactCustomerService:(NSString *)url {
    NSURL *openUrl = [NSURL URLWithString:StringWithFormat(@"tel://%@", url)];
    if ([[UIApplication sharedApplication] canOpenURL:openUrl]) {
        [[UIApplication sharedApplication] openURL:openUrl];
    } else {
        [UIAlertController showAlertController:UIAlertControllerStyleAlert Title:@"拨号" DetailTitle:@"无法联系客服" DefaultTitle:nil CancelTitle:@"取消" Delegate:KeyWindow.rootViewController DefaultAction:^(NSString *selectedTitle) {
            
        } CancelAction:^{
            
        }];
    }
}
#pragma mark- 验证码按钮倒计时方法
- (void)codeBtnCountdown:(UIButton *)codeBtn Pattern:(int)pattern {
    self.tempCodeTime = self.tempCodeTime != 0?self.tempCodeTime:codeTime;
    if(pattern == 2&&self.tempCodeTime == codeTime) {
        return;
    }
    [codeBtn setTitle:[NSString stringWithFormat:@"(%ds)", self.tempCodeTime--] forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(codeBtnNumChange:) userInfo:@{@"object":codeBtn} repeats:YES];
    
}
- (void)codeBtnNumChange:(NSTimer *)timer {
    NSDictionary *userInfo = timer.userInfo;
    UIButton *codeBtn = userInfo[@"object"];
    if (self.tempCodeTime != 0) {
        [codeBtn setTitle:[NSString stringWithFormat:@"(%ds)",self.tempCodeTime--] forState:UIControlStateNormal];
        codeBtn.userInteractionEnabled = NO;
    } else {
        [codeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        codeBtn.userInteractionEnabled = YES;
        [timer invalidate];
    }
}
#pragma mark- tableViewCell圆角
+ (void)cellSetRound:(UITableView *)tableView Cell:(UITableViewCell *)cell IndexPath:(NSIndexPath *)indexPath SideSpace:(CGFloat)margin {
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 5.f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, margin, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        } else if (indexPath.row == 0) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            
        } else {
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        layer.fillColor = [UIColor colorWithWhite:1.f alpha:1.f].CGColor;
        if (addLine == YES&&tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+tableView.separatorInset.left, bounds.size.height-lineHeight, bounds.size.width-tableView.separatorInset.left-tableView.separatorInset.right, lineHeight);
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}
#pragma mark- 获取DocumentsPath
- (NSString *)setDocumentsPath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return documentsPath;
}
#pragma mark- 获取手机IP
- (NSString*)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // 检索当前接口,在成功时,返回0
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // 循环链表的接口
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // 检查接口是否en0 wifi连接在iPhone上
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // 得到NSString从C字符串
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放内存
    freeifaddrs(interfaces);
    return address;
}
#pragma mark- 获取手机UUID
- (NSString *)getUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *UUID =CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return UUID;
}
#pragma mark-判断是否是 iPhone X以上版本
- (BOOL)beyond_iPhoneX {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = AppDelegateShare.window;
        if (window.safeAreaInsets.bottom > 0.0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

#pragma mark - 时间显示
/**
 *  显示几分钟前、几小时前等 str格式：yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)compareCurrentTime:(NSString *)str{

    // 如果字符串包含.0 要截取
    if ([str containsString:@"."]) {
        str = [str componentsSeparatedByString:@"."].firstObject;
    }
    
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];

    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;

    //标准时间和北京时间差8个小时
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }

    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }

    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }

    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }

    return  result;
}

#pragma mark- 单例
+(QLToolsManager *)share {
    static QLToolsManager *wayTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wayTool = [QLToolsManager new];
    });
    return wayTool;
}
@end

