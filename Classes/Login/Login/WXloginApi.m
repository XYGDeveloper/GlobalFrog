//
//  WXloginApi.m
//  Qqw
//
//  Created by XYG on 16/8/28.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "WXloginApi.h"

@implementation WXloginApi

- (void)wxLoginWithNikeName:(NSString *)nickname openId:(NSString *)openid sex:(NSString *)sex face:(NSString *)face type:(NSString *)type
{
    
    NSDictionary *params = @{@"nickname": nickname ?:@"",
                             @"openid": openid ?:@"",
                             @"sex": sex ?:@"",
                             @"face": face ?:@"",
                             @"type": type ?:@""
                             };
    [self startRequestWithParams:params];
    
}



- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = THIRD_LOGIN_URL;
    
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    return responseObject;
    
    
}
@end
