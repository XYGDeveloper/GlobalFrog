//
//  OrderListApi.h
//  Qqw
//
//  Created by zagger on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseListApi.h"
#import "OrderModel.h"

@interface OrderListApi : BaseListApi

- (id)initWithOrderStatus:(NSString *)orderStatus;

@end
