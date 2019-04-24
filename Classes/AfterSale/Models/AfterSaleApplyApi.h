//
//  AfterSaleApplyApi.h
//  Qqw
//
//  Created by zagger on 16/9/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

@interface AfterSaleApplyApi : BaseApi

/**
 *  申请售后
 *
 *  @param orderId      申请售后的订单id
 *  @param goodsIdArray 申请售后的商品id
 *  @param productId    申请售后的产品id
 *  @param type         申请售后的类型
 *  @param explain      申请售后的说明信息
 */
- (void)applyWithOrder:(NSString *)orderId
                 goods:(NSArray *)goodsIdArray
               product:(NSArray *)productIdArray
                  type:(NSString *)type
               explain:(NSString *)explain;

@end
