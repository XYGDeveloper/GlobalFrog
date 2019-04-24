//
//  MyRequestApiClient.h
//  Qqw
//
//  Created by 全球蛙 on 2017/2/24.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"


@interface MyRequestApiClient : BaseApi

@property(nonatomic,assign) AFNetworkReachabilityStatus networkStatus ;

+ (instancetype)sharedClient;

+ (void)checkNetwork;

+(void)requestGETUrl:(NSString*)url parameters:(id)data superView:(UIView*)view finshBlock:(void (^)(NSDictionary * obj,NSError * error))finshBlock;

+(void)requestPOSTUrl:(NSString*)url parameters:(NSDictionary*)data superView:(UIView*)view finshBlock:(void (^)(NSDictionary * obj,NSError * error))finshBlock;



@end
