//
//  ResigterApi.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/27.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BingWXLoginApi.h"

@implementation BingWXLoginApi

- (void)getVerifyCodeWithPhone:(NSString *)phone password:(NSString *)password varCode:(NSString *)varCode{
    
    NSDictionary *params = @{@"mobile": phone ?:@"",@"password": password ?:@"",@"smscode": varCode ?:@""};
    [self startRequestWithParams:params];
    
}

- (ApiCommand *)buildCommand {
    
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/user-main/bindMobile");
    
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    return responseObject;
    
    
}


@end
