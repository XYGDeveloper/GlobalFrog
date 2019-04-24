//
//  MyRequestApiClient.m
//  Qqw
//
//  Created by 全球蛙 on 2017/2/24.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "MyRequestApiClient.h"
#import "ApiManager.h"
@implementation MyRequestApiClient

+ (instancetype)sharedClient {
    static MyRequestApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient =[MyRequestApiClient new];
    });
    return _sharedClient;
}


+(void)requestGETUrl:(NSString *)url parameters:(id)data superView:(UIView *)view finshBlock:(void (^)(NSDictionary *, NSError *))finshBlock{
    
    ApiCommand *cmd =[ApiCommand getApiCommand];
    cmd.requestURLString =  url;
    cmd.parameters = data;
    
    if (view) {
        [Utils addHudOnView:view];
    }
    if (!data) {
        data = @{};
    }
#ifdef DEBUG
    //    NSLog(@"POST to URL: %@, %@", url, data);
#endif
    [ [ApiManager sharedManager] requestWithCommand:cmd constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(NSURLSessionDataTask *task, ApiCommand *command, id responseObject) {
        [Utils removeHudFromView:view];
#ifdef DEBUG
        //   NSLog(@"Response of URL: %@, %@  %@", url,responseObject, responseObject[@"msg"]);
#endif
        NSString * s = responseObject[@"ret"];
        if (s.intValue == 0) {
            finshBlock(responseObject[@"data"],nil);
        }else{
            [Utils showErrorMsg:view type:0 msg:responseObject[@"msg"]];

            finshBlock(nil,[NSError new]);
        }
        
    } failure:^(NSURLSessionDataTask *task, ApiCommand *command, NSError *error) {
        [Utils removeHudFromView:view];
        [Utils showErrorMsg:view type:0 msg:@"服务器异常"];

#ifdef DEBUG
        NSLog(@"%@",error);
#endif
        finshBlock(nil,error);
    }];

}

+(void)requestPOSTUrl:(NSString *)url parameters:(NSDictionary *)data superView:(UIView *)view finshBlock:(void (^)(NSDictionary *, NSError *))finshBlock{
    ApiCommand *cmd =[ApiCommand defaultApiCommand];
    cmd.requestURLString =  url;
    cmd.parameters = data;
    
    if (view) {
        [Utils addHudOnView:view];
    }
    
    if (!data) {
        data = @{};
    }
#ifdef DEBUG
//    NSLog(@"POST to URL: %@, %@", url, data);
#endif
    [ [ApiManager sharedManager] requestWithCommand:cmd constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(NSURLSessionDataTask *task, ApiCommand *command, id responseObject) {
        [Utils removeHudFromView:view];
#ifdef DEBUG
//        NSLog(@"Response of URL: %@, %@  %@", url,responseObject, responseObject[@"msg"]);
#endif
        NSString * s = responseObject[@"ret"];
        if (s.intValue == 0) {
            finshBlock(responseObject[@"data"],nil);
        }else{
            [Utils showErrorMsg:view type:s.intValue msg:responseObject[@"msg"]];
            finshBlock(nil,[NSError new]);
        }
        
    } failure:^(NSURLSessionDataTask *task, ApiCommand *command, NSError *error) {
        [Utils removeHudFromView:view];
#ifdef DEBUG
        NSLog(@"%@",error);
#endif
        if ([MyRequestApiClient sharedClient].networkStatus == AFNetworkReachabilityStatusNotReachable) {
            [Utils showErrorMsg:view type:0 msg:@"网络连接有问题,稍后重试"];
//            [[EmptyManager sharedManager] showNetErrorOnView:view response:nil operationBlock:nil];
        }else{
            [Utils showErrorMsg:view type:0 msg:@"服务器异常"];
        }
        finshBlock(nil,error);
        
    }];
    
}

+ (void)checkNetwork{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        [MyRequestApiClient sharedClient].networkStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"无网络");
//                ALERT_MSG(@"当前网络连接异常");
                   [Utils showErrorMsg:[AppDelegate APP].window type:0 msg:@"当前网络连接异常"];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"WiFi网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"无线网络");
                break;
            }
                
            default:
                break;
        }
    }];
//    [[AFNetworkReachabilityManager sharedManager]  startMonitoring];
}

@end
