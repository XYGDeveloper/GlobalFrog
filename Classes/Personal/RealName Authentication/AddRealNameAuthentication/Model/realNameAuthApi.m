//
//  realNameAuthApi.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "realNameAuthApi.h"

@implementation realNameAuthApi

- (void)upRealNameAuthInfoWithName:(NSString *)name
                         isDefault:(NSString *)is_default
                            number:(NSString *)number
                              face:(NSString *)face
                              back:(NSString *)back
{

    NSDictionary *parameters = @{@"name": name ?: @"",
                                 @"is_default": is_default ?: @"",
                                 @"number": number ?: @"",
                                 @"face": face ?: @"",
                                 @"back": back ?: @"",
                                 };
    
    [self startRequestWithParams:parameters];
    
}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = USER_ID_ADD_URL;//APIURL(@"/user-idcard/add");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    return responseObject;
    
}
@end
