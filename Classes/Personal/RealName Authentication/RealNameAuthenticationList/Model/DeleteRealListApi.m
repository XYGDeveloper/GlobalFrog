//
//  DeleteRealListApi.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "DeleteRealListApi.h"

@implementation DeleteRealListApi

- (void)toDeleteListWithId:(NSString *)realId
{

    NSDictionary *parameters = @{@"id": realId ?: @"",
                                 };
    [self startRequestWithParams:parameters];

}


- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = USER_ID_DET_URL;//APIURL(@"/user-idcard/del");
    return command;
}

- (id)reformData:(id)responseObject {
    
    return responseObject;
    
}


@end
