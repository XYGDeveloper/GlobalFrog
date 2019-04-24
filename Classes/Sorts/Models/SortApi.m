//
//  SortApi.m
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "SortApi.h"
#import "SortListItem.h"

@implementation SortApi

- (void)getGoodsCategory {
    [self startRequestWithParams:nil];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/category-main/");
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *jsonArray = [responseObject objectForKey:@"list"];
    return [SortListItem mj_objectArrayWithKeyValuesArray:jsonArray];
}

@end
