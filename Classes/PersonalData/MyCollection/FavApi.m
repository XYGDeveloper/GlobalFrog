//
//  FavApi.m
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "FavApi.h"
#import "ShopModel.h"

@implementation FavApi

- (void)refreshWithType:(NSString *)type {
    [self refreshWithParams:@{@"type":type?:@""}];
}

- (void)loadNextPageWithType:(NSString *)type {
    [self loadNextPageWithParams:@{@"type":type?:@""}];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.method = QQWRequestMethodGet;
    command.requestURLString = APIURL(@"/goods-favorite/list");
    return command;
    
    
}

- (id)reformData:(id)responseObject {
    return [ShopModel mj_objectArrayWithKeyValuesArray:responseObject];
}

@end


@implementation AddFavApi

- (void)addFavWithGoodsIds:(NSArray *)goodsIdArray {
    NSString *str = [goodsIdArray componentsJoinedByString:@","];
    [self startRequestWithParams:@{@"goods_id": str ?: @""}];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"goods-favorite/add");
    return command;
}

@end



@implementation DeleteFavApi

- (void)deleteFavWithGoodsId:(NSString *)goodsId {
    [self startRequestWithParams:@{@"goods_id": goodsId ?: @""}];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.method = QQWRequestMethodGet;
    command.requestURLString = APIURL(@"/goods-favorite/del");
    return command;
}

@end



@interface FavApiManager ()<ApiRequestDelegate>

@property (nonatomic, strong) AddFavApi *addApi;

@property (nonatomic, strong) DeleteFavApi *deleteApi;

@property (nonatomic, copy) void(^completionBlock)(ApiCommand *cmd, BOOL success);

@end

@implementation FavApiManager

- (void)addFavWithGoodsIds:(NSArray *)goodsIdArray completionBlock:(void(^)(ApiCommand *cmd, BOOL success))completionBlock {
    self.completionBlock = completionBlock;
    [self.addApi addFavWithGoodsIds:goodsIdArray];
}

- (void)deleteFavWithGoodsId:(NSString *)goodsId completionBlock:(void(^)(ApiCommand *cmd, BOOL success))completionBlock {
    self.completionBlock = completionBlock;
    [self.deleteApi deleteFavWithGoodsId:goodsId];
}

#pragma makr - ApiRequestDelegate
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    if (self.completionBlock) {
        self.completionBlock(command, YES);
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    if (self.completionBlock) {
        self.completionBlock(command, NO);
    }
}

- (AddFavApi *)addApi {
    if (!_addApi) {
        _addApi = [[AddFavApi alloc] init];
        _addApi.delegate = self;
    }
    return _addApi;
}

- (DeleteFavApi *)deleteApi {
    if (!_deleteApi) {
        _deleteApi = [[DeleteFavApi alloc] init];
        _deleteApi.delegate = self;
    }
    return _deleteApi;
}

@end
