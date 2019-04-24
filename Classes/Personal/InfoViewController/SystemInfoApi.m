//
//  SystemInfoApi.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/14.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "SystemInfoApi.h"
#import "SystemInfoModel.h"
@implementation SystemInfoApi

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand getApiCommand];
    command.requestURLString = MSG_LIST_URL;//APIURL(@"/user-message/index");
    return command;
    
}
- (id)reformData:(id)responseObject {
    
    NSLog(@"系统消息%@",responseObject[@"list"]);
    NSArray *array = [SystemInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
    return array;
    
}


@end
