//
//  BrandFactoryListApi.m
//  Qqw
//
//  Created by zagger on 16/9/9.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BrandFactoryListApi.h"
#import "BrandFactory.h"

@implementation BrandFactoryListApi

- (ApiCommand *)buildCommand {
    ApiCommand *command  = [ApiCommand defaultApiCommand];
    command.method = QQWRequestMethodGet;
    command.requestURLString = APIURL(@"/goods-brand/list");
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *jsonArray = [responseObject objectForKey:@"list"];
    return [BrandFactory mj_objectArrayWithKeyValuesArray:jsonArray];
}


@end
