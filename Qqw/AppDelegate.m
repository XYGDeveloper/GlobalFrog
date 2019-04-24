//
//  AppDelegate.m
//  Qqw
//
//  Created by gao.jian on 16/6/22.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import <UMSocial.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import <UMSocialQQHandler.h>
#import "User.h"
#import "ShareModel.h"
#import "Payment.h"
#import "RootManager.h"
#import <JPUSHService.h>
#import <AdSupport/AdSupport.h>

#import "WXApiManager.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setUpForDismissKeyboard];
    [AMapServices sharedServices].apiKey = GDMAP_KEY;
    
    [[GlobalManager sharedManager] startSetup];
    //配置第三方平台账号
    [self configThird];
    NSLog(@"%@",NSHomeDirectory());
    self.window.rootViewController = [[StartUpViewController alloc] init];
    
    self.myMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2+20)];
    self.myMapView.showsUserLocation = YES;
    self.myMapView.zoomLevel = 15;
//    self.myMapView.minZoomLevel = 10;
//    self.myMapView.maxZoomLevel = 17;
    self.myMapView.rotateCameraEnabled = NO;
    self.myMapView.rotateEnabled = NO;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([Utils shouldShowGuidePage]) {
            GuideViewController *guideVC = [[GuideViewController alloc] init];
            self.window.rootViewController = guideVC;
        } else {
            self.window.rootViewController = [RootManager sharedManager].tabbarController;
            [[RootManager sharedManager].tabbarController setSelectedIndex:1];
        }
    });
    
#pragma mark-以下为极光推送///////////////////////////////////////////////////////////////
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:kAppKey
                          channel:channel
                 apsForProduction:YES
            advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            //获取到注册id，保存后，登录时提交到个人资料
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"token"];
        }else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    [MyRequestApiClient checkNetwork];
    return YES;
}

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.window addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.window removeGestureRecognizer:singleTapGR];
                }];
}
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.window endEditing:YES];
}


//配置第三方平台账号
- (void)configThird {

    /**
     *  bugly配置
     */
//    [Bugly startWithAppId:kBuglyAppId];



    /**
     *  友盟第三方配置
     */
    [UMSocialData setAppKey:kUMengAppKey];
    
    [UMSocialConfig shareInstance].hiddenStatusTip = YES;
    [UMSocialWechatHandler setWXAppId:kWechatAppId appSecret:kWechatAppSecret url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:kQQAppId appKey:kQQAppSecret url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSinaAppId
                                              secret:kSinaAppSecret
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    /**
     *  友盟统计配置
     */
    UMConfigInstance.appKey = kUmengStatic;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [MobClick setAppVersion:[UIDevice AppVersion]];
    [MobClick setCrashReportEnabled:YES];
    
}



+(AppDelegate *)APP{
    return (AppDelegate*) [UIApplication sharedApplication].delegate;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
     [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"%@",url);
    return [self canHandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSLog(@"%@  %@",url,url.host);
    return [self canHandleOpenURL:url];
}

- (BOOL)canHandleOpenURL:(NSURL *)url {
    BOOL result = NO;
    if ([url.host isEqualToString:@"pay"]) { //微信支付
       return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else if ([url.host isEqualToString:@"safepay"]) {//支付宝支付
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[AlipayService defaultService] payOrderDidFinishedWithInfo:resultDic];
        }];
        return YES;
    }
    else {
        return [UMSocialSnsService handleOpenURL:url];
    }
    
    return result;
}



- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
  
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState == UIApplicationStateActive) {
        //这里写APP正在运行时，推送过来消息的处理
        [self controllJumpToViewControllerWith:userInfo];
        
    } else if (application.applicationState == UIApplicationStateInactive ) {
        
        //APP在后台运行，推送过来消息的处理
        [self controllJumpToViewControllerWith:userInfo];
        
    } else if (application.applicationState == UIApplicationStateBackground) {
        
        //APP没有运行，推送过来消息的处理
        [self controllJumpToViewControllerWith:userInfo];
        
    }
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
   
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
         NSLog(@"type:%@",[userInfo objectForKey:@"type"]);

        [self controllJumpToViewControllerWith:userInfo];
        
    }
    
    completionHandler();  // 系统要求执行这个方法
}

#endif


- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    
    return str;
    
}

//控制页面跳转的方法

- (void)controllJumpToViewControllerWith:(NSDictionary*)msgDic{
    
    if ([msgDic[@"type"]isEqualToString:kOpenAppliacation]) {

        [Utils jumpToTabbarControllerAtIndex:0];
        
    } else if ([msgDic[@"type"]isEqualToString:kjumpWithWebPage]) {
        WebViewController *vc = [[WebViewController alloc] initWithURLString:msgDic[@"value"]];
        [self.window.rootViewController.navigationController pushViewController:vc animated:YES];
    } 
    
}


@end
