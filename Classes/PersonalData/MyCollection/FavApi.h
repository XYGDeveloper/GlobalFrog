//
//  FavApi.h
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseListApi.h"

@interface FavApi : BaseListApi

- (void)refreshWithType:(NSString *)type;

- (void)loadNextPageWithType:(NSString *)type;



@end



@interface AddFavApi : BaseApi

- (void)addFavWithGoodsIds:(NSArray *)goodsIdArray;

@end



@interface DeleteFavApi : BaseApi

- (void)deleteFavWithGoodsId:(NSString *)goodsId;

@end





@interface FavApiManager : NSObject

- (void)addFavWithGoodsIds:(NSArray *)goodsIdArray completionBlock:(void(^)(ApiCommand *cmd, BOOL success))completionBlock;

- (void)deleteFavWithGoodsId:(NSString *)goodsId completionBlock:(void(^)(ApiCommand *cmd, BOOL success))completionBlock;

@end