//
//  DeleSystemInfoApi.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/16.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "DeleSystemInfoApi.h"

@implementation DeleSystemInfoApi

- (void)deleCollectWithID:(NSString *)messageId
{
    
    NSDictionary *Paras = @{
                        @"id": messageId ?: @"",
                           };
    
    [self startRequestWithParams:Paras];
    
    
}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand getApiCommand];
    command.requestURLString = APIURL(@"/user-message/delete");
    return command;
    
}



- (id)reformData:(id)responseObject {
    
    
    return responseObject;
    
}

@end
