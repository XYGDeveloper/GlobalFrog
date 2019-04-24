//
//  AttentionModel.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/13.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "AttentionModel.h"

@implementation AttentionModel

+(void)requestAttentuonWithFuid:(NSString*)fuid type:(int)type superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    NSString * url = nil;
    if (type == 0) {
        url = ATTENTION_URL;
    }else{
        url = UN_ATTENTION_URL;
    }
    
    [MyRequestApiClient requestGETUrl:url parameters:@{@"fuid":fuid} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (error == nil) {
            
            finshBlock(nil,nil);
        }
    }];

}

+(void)requestAttentuonListWithDataArray:(NSMutableArray*)dataArray page:(int)page superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    
    [MyRequestApiClient requestGETUrl:ATTENTION_LIST_URL parameters:@{@"p":@(page)} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (error == nil) {
            NSDictionary * dic  = obj[@"list"];
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            [dataArray addObjectsFromArray:[AttentionModel mj_objectArrayWithKeyValuesArray:dic]];
            finshBlock(nil,nil);
        }else{
            finshBlock(nil,error);
        }
    }];
    
}


@end
