//
//  ConponModel.m
//  Qqw
//
//  Created by 全球蛙 on 16/8/24.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "ConponModel.h"

@implementation ConponModel

+(void)requestConponWithDataArray:(NSMutableArray *)dataArray type:(CouponType)type page:(int)page superView:(UIView *)superView finshBlock:(void (^)(id, NSError *))finshBlock{
    [MyRequestApiClient requestPOSTUrl:COUPON_LIST_URL parameters:@{@"type": @(type+1)} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [dataArray removeAllObjects];
            [dataArray  addObjectsFromArray:[ConponModel mj_objectArrayWithKeyValuesArray:obj[@"list"]]];

            finshBlock(nil,nil);
        }else{
            finshBlock(nil,[NSError new]);
        }
    }];
}



@end
