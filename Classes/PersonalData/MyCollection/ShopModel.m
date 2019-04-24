//
//  ShopModel.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

+(void)requestShopWithGoodsId:(NSString*)goodsid type:(int)type superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    NSString * url = nil;
    if (type == 0) {
        url = ADD_FAVORITE_URL;
        [MyRequestApiClient requestPOSTUrl:url parameters:@{@"goods_id":goodsid} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
            if (error == nil) {
                
                finshBlock(nil,nil);
            }
        }];
    }else{
        url = DEL_FAVORITE_URL;
        [MyRequestApiClient requestGETUrl:url parameters:@{@"goods_id":goodsid} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
            if (error == nil) {
                
                finshBlock(nil,nil);
            }
        }];
    }
}

+(void)requestShopListWithDataArray:(NSMutableArray*)dataArray page:(int)page superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    [MyRequestApiClient requestGETUrl:FAVORITE_URL parameters:@{@"p":@(page)} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (error == nil) {
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            [dataArray addObjectsFromArray:[ShopModel mj_objectArrayWithKeyValuesArray:obj]];
            finshBlock(nil,nil);
        }else{
            finshBlock(nil,error);
        }
    }];
}

@end
