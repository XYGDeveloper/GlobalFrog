//
//  CreateOrderInfo.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/23.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "CreateOrderInfo.h"

@implementation CreateOrderInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _goods = [NSMutableArray new];
        _remarklist = [NSMutableArray new];
        _s = @"1";
    }
    return self;
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"remarklist":[RemarkInfo class],
             @"goods":[OrderOkInfo class]};
}

+(void)requestCreateOrderWithInfo:(OrderConfirmItem *)info superView:(UIView *)superView finshBlock:(void (^)(id obj, NSError * error))finshBlock{
//    NSDictionary * dic  =info.mj_keyValues;
//    NSLog(@"%@",dic);
    
    CreateOrderInfo * c = [CreateOrderInfo new];
    c.address_id = info.address.address_id;
    c.coupon_id = info.couponId;
    
    [c.remarklist removeAllObjects];
    for (CartGroupItem * goods in info.newgoods) {
        RemarkInfo * m  = [RemarkInfo new];
        m.rtype = goods.rtype;
        m.value = goods.remark;
        [c.remarklist addObject:m];
        if (goods.rtype == 4) {
            c.gettime = goods.time;
            if (!c.gettime) {
                [Utils showErrorMsg:superView type:0 msg:@"请选择配送时间"];
                return;
            }
        }
        for (CartGoodsModel * car in goods.list) {
            OrderOkInfo * o = [OrderOkInfo new];
            o.sku_id = car.sku_id;
            o.goods_number = car.goods_number;
            [c.goods addObject:o];
        }
    }

//    NSString *orderForm = [Utils stringFromJsonObject:c.mj_keyValues];
    [MyRequestApiClient requestPOSTUrl:CREATE_ORDE_URL parameters:@{@"orderForm":c.mj_JSONString?: @""} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            OrderModel *item = [OrderModel mj_objectWithKeyValues:obj];
            finshBlock(item,nil);
        }else{
            finshBlock(nil,[NSError new]);
        }
    }];
}

@end

@implementation OrderOkInfo



@end


@implementation RemarkInfo



@end
