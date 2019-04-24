//
//  TopicListApi.m
//  Qqw
//
//  Created by zagger on 16/9/1.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "TopicListApi.h"
#import "TopicItem.h"

@implementation TopicListApi

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/butler-article/special");
    command.method = QQWRequestMethodGet;
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *jsonArray = [responseObject safeObjectForKey:@"list"];
    return [TopicItem mj_objectArrayWithKeyValuesArray:jsonArray];
}

@end
