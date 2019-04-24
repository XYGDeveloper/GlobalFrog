//
//  LoginApi.m
//  Qqw
//
//  Created by XYG on 16/8/28.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "LoginApi.h"

@implementation LoginApi

- (void)loginWithPhone:(NSString *)phone password:(NSString *)password
{
    
    NSDictionary *params = @{@"mobile": phone ?:@"",@"password": password ?:@""};
    [self startRequestWithParams:params];
    
    
}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = LOGIN_URL;
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    NSLog(@"-----------%@",responseObject);
    return responseObject;
    
    
}




@end
