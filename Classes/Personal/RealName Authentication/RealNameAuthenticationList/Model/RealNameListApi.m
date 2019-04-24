//
//  RealNameListApi.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "RealNameListApi.h"
#import "RealListModel.h"
@implementation RealNameListApi

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand getApiCommand];
    command.requestURLString = USER_ID_LIST_URL;//APIURL(@"/user-idcard/list");
    return command;
}

- (id)reformData:(id)responseObject {
    
    NSLog(@"实名列表：%@",responseObject);
    NSArray *array = [RealListModel mj_objectArrayWithKeyValuesArray:responseObject];
    return array;
}

@end
