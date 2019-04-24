//
//  RealListModel.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "RealListModel.h"

@implementation RealListModel

+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"rID" : @"id",};
}


+(void)requestRealListWithSuperView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    [MyRequestApiClient requestPOSTUrl:USER_ID_LIST_URL parameters:nil superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock([RealListModel mj_objectArrayWithKeyValuesArray:obj],nil);
        }else{
            finshBlock(nil,[NSError new]);
        }
    }];
}

+(void)requestEditRealWithId:(NSString*)rID type:(int)type superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    NSString * url = nil;
    if (type == 0) {
        url = USER_ID_DEFAULT_URL;
    }else{
        url = USER_ID_DET_URL;
    }
    
    [MyRequestApiClient requestPOSTUrl:url parameters:@{@"id": rID} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(nil,nil);
        }
    }];
}

@end
