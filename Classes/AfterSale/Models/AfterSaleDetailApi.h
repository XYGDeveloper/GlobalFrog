//
//  AfterSaleDetailApi.h
//  Qqw
//
//  Created by zagger on 16/9/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"
#import "AfterSaleModel.h"

@interface AfterSaleDetailApi : BaseApi

- (void)getAfterSaleDetailWithIdentifier:(NSString *)return_sn;

@end
