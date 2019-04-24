//
//  DoyenListApi.m
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "DoyenListApi.h"
#import "DoyenListItem.h"

@implementation DoyenListApi

- (void)getDiscoverTopicList {
    [self startRequestWithParams:nil];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.method = QQWRequestMethodGet;
    command.requestURLString = APIURL(@"/find-main/");
    return command;
}

- (id)reformData:(id)responseObject {
    
    NSLog(@"%@",responseObject);
    NSArray *array = [DoyenListItem mj_objectArrayWithKeyValuesArray:responseObject[@"doyen"]];
    return array;
}

@end
