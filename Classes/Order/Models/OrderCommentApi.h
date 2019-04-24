//
//  OrderCommentApi.h
//  Qqw
//
//  Created by zagger on 16/9/3.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

@interface OrderCommentApi : BaseApi

- (void)submitComment:(NSArray *)goodsCmtArray forOrder:(NSString *)orderId anonymity:(BOOL)anonymity;

@end
