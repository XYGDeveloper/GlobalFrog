//
//  DefaultApi.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "DefaultApi.h"

@implementation DefaultApi


- (void)toSetDefaultWithId:(NSString *)realId
{

    NSDictionary *parameters = @{@"id": realId ?: @"",
                                 };
    
    [self startRequestWithParams:parameters];


}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = USER_ID_DEFAULT_URL;//APIURL(@"/user-idcard/setdefault");
    return command;
}

- (id)reformData:(id)responseObject {
    
    return responseObject;
    
}


@end
