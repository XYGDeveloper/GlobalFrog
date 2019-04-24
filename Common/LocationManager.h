//
//  LocationManager.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/28.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^SuccessLocationBlock)(CLPlacemark *placeMark);
typedef void(^FailureLocationBlock)(NSError * error);
typedef void(^UpdateLocationBlock)(CLLocation * tmpLocation);

@interface LocationManager : NSObject<CLLocationManagerDelegate>{
    CLLocationManager * locationManager;
}

@property(nonatomic,copy,readonly) SuccessLocationBlock successBlock;
@property(nonatomic,copy,readonly) FailureLocationBlock failureBlock;
@property(nonatomic,copy,readonly) UpdateLocationBlock updateBlock;


+ (instancetype)sharedManager;

-(void)startLocationUpdateLocation:(UpdateLocationBlock)updateBlock Success:(SuccessLocationBlock)successBlock failure:(FailureLocationBlock)failureBlock;

@end
