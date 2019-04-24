//
//  IsRealNameAuthApi.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "IsRealNameAuthApi.h"

@implementation IsRealNameAuthApi

- (void)toJudgeIsRealNameAuthWithGoods_id_list:(NSString *)goods_id_list{

    NSDictionary *parameters = @{@"goods_id_list": goods_id_list ?: @""};
    [self startRequestWithParams:parameters];
    
}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = USER_IDCARD_URL;//APIURL(@"/user-idcard/check");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    return responseObject;
    
}
@end
