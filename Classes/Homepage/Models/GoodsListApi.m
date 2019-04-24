//
//  GoodsListApi.m
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "GoodsListApi.h"
#import "GoodsModel.h"

@interface GoodsListApi ()

@end

@implementation GoodsListApi

- (void)refresh {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.sortId forKey:@"cat_id"];
    [params safeSetObject:self.brandId forKey:@"brand_id"];
    
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.sortId forKey:@"cat_id"];
    [params safeSetObject:self.brandId forKey:@"brand_id"];
    
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.method = QQWRequestMethodGet;
    command.requestURLString = GOODS_LIST_URL;
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *jsonArray = [responseObject objectForKey:@"list"];
    return [GoodsModel mj_objectArrayWithKeyValuesArray:jsonArray];
}

@end
