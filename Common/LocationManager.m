//
//  LocationManager.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/28.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LocationManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LocationManager alloc] init];
    });
    return instance;
}

- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter=kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }else{
        ALERT_MSG(@"未开启定位功能");
    }
}

-(void)startLocationUpdateLocation:(UpdateLocationBlock)updateBlock Success:(SuccessLocationBlock)successBlock failure:(FailureLocationBlock)failureBlock{
    _updateBlock = updateBlock;
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    
    [self startLocation];

}

#pragma mark ================== location delegate =================
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied :{
            
            UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"请在设置-隐私-定位服务中开启定位功能！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tempA show];
        }
            break;
        case kCLAuthorizationStatusNotDetermined :
            if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
                [locationManager requestAlwaysAuthorization];
            }
            break;
        case kCLAuthorizationStatusRestricted:{
            // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
            UIAlertView *tempA = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"定位服务无法使用！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tempA show];
        }
        default:
            
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    if (_updateBlock) {
        _updateBlock(currentLocation);
    }
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            _successBlock(placeMark);
            
        }else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }else if (error) {
            NSLog(@"location error: %@ ",error);
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [locationManager stopUpdatingLocation];
    _failureBlock(error);
}


@end
