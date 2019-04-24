//
//  QQLoginApi.m
//  Qqw
//
//  Created by 全球蛙 on 2016/11/22.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "QQLoginApi.h"

@implementation QQLoginApi


- (void)QQLoginWithNikeName:(NSString *)nickname openId:(NSString *)openid sex:(NSString *)sex face:(NSString *)face type:(NSString *)type
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
