//
//  AppDelegate.h
//  Qqw
//
//  Created by gao.jian on 16/6/22.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong) MAMapView * myMapView;

@property(assign, nonatomic) CLLocationCoordinate2D locationCoordinate;

+(AppDelegate*)APP;

@end

