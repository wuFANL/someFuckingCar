//
//  JGLocationManager.m
//  QL
//
//  Created by tarena on 16/5/25.
//  Copyright © 2016年 JGS. All rights reserved.
//

#import "QLLocationManager.h"
#import "UIAlertController+QLUtil.h"
@interface QLLocationManager()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
//记录用户的位置的block(block属性声明和.h中的block一样)
@property (nonatomic, strong) LocationManagerCompletionHandler completionBlock;
//地理编码属性
@property (nonatomic,strong) CLGeocoder *geocoder;
@end

@implementation QLLocationManager

+ (instancetype)sharedLocationManager {
    static QLLocationManager *sharedLoationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLoationManager = [[QLLocationManager alloc] init];
    });
    return sharedLoationManager;
}
//在init方法中初始化值
-(instancetype)init
{
    self = [super init];
    if (self) {
        //初始化location为nil
        _location = nil;
        //初始化geocoder
        self.geocoder = [CLGeocoder new];
    }
    return self;
}
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        //1.初始化manager对象
        _locationManager = [CLLocationManager new];
        //2.征求用户的同意(iOS8+;Info.plist)
        [_locationManager requestWhenInUseAuthorization];
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //3.设置代理
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)updateLocationWithCompletionHandler:(LocationManagerCompletionHandler)completion {
    //判断用户是否把“定位功能”打开，如果没有打开，给控制器返回错误
    if ([CLLocationManager locationServicesEnabled]&&[CLLocationManager authorizationStatus] !=kCLAuthorizationStatusDenied) {
        //调用开始定位
        [self.locationManager startUpdatingLocation];
        //把completion赋值给block属性（block对象的地址指向同一片内存）
        self.completionBlock = completion;
    } else {
        //1.创建NSError对象，传给completion
        NSError *error = [NSError errorWithDomain:@"location" code:10 userInfo:[NSDictionary dictionaryWithObject:@"location service is disabled" forKey:NSLocalizedDescriptionKey]];
        completion(nil,error);
        //弹框提示
        [UIAlertController showAlertController:UIAlertControllerStyleAlert Title:@"打开定位开关" DetailTitle:@"定位服务未开启，请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务" DefaultTitle:@[@"立即开启"] CancelTitle:@"取消" Delegate:nil DefaultAction:^(NSString *selectedTitle) {
            if ([selectedTitle isEqualToString:@"立即开启"]) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        } CancelAction:^{
            
        }];
        //2.直接return
        return;
    }
    }
//成功返回用户的位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //停止定位
    [self.locationManager stopUpdatingLocation];
    //获取最新的用户位置
    CLLocation *userLocation = [locations lastObject];
    //把用户的位置赋值给.h属性
    _location = userLocation;
    //把用户的位置传给completionBlock属性（调用）
    if (self.completionBlock) {
        self.completionBlock(userLocation,nil);
    //把当前的block对象赋值为nil
        self.completionBlock = nil;
    }
    
}
//失败返回用户的位置
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //停止定位
    [self.locationManager stopUpdatingLocation];

    //错误error对象回传
    if (self.completionBlock) {
        self.completionBlock(nil,error);
        
    }
}

- (void)updateCityWithCompletionHandler:(CityCompletionHandler)completion {
    [self updateLocationWithCompletionHandler:^(CLLocation *location, NSError *error) {
    //获取用户位置
        if (!error) {
            //反向地理编码
            [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                CLPlacemark *placemark = [placemarks lastObject];
                //给block赋值
                completion(placemark,location,nil);
            }];
            
        } else {
            //有错
            completion(nil,nil,error);
        }

    }];
    
}

@end
