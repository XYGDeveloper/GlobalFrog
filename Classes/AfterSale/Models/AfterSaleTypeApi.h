//
//  AfterSaleTypeApi.h
//  Qqw
//
//  Created by zagger on 16/9/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

/**
 *  获取售后类型
 */
@interface AfterSaleTypeApi : BaseApi

- (void)getAfteSaleType;

@end


/**
 *  售后类型
 */
@interface AfterSaleType : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;

@end