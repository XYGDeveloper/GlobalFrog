//
//  PrivateMsgApi.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/14.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "PrivateMsgApi.h"
#import "PrivateMsgModel.h"
@implementation PrivateMsgApi

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand getApiCommand];
    command.requestURLString = MSG_INDEX_URL;//APIURL(@"/user-pm/index");
    return command;
}

- (id)reformData:(id)responseObject {
    
    NSArray *ListArr = responseObject[@"list"];
    NSLog(@"listArr:%@",ListArr);
    NSArray *array = [PrivateMsgModel mj_objectArrayWithKeyValuesArray:ListArr];
    
    return array;
}

@end
