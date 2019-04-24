//
//  VipApi.m
//  Qqw
//
//  Created by zagger on 16/8/29.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "VipApi.h"

@implementation VipExplain

- (BOOL)isFree {
    return [self.price floatValue] <= 0;
}

@end



@implementation VipApi

- (void)getVipExplain {
    [self startRequestWithParams:nil];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.method = QQWRequestMethodGet;
    command.requestURLString = VIP_URL;//APIURL(@"/butler-main/show");
    return command;
}

- (id)reformData:(id)responseObject {
    VipExplain *explain = [VipExplain mj_objectWithKeyValues:responseObject];
    return explain;
}
@end





@implementation BecomeVipReq

@end



@implementation BecomeVipApi

- (void)becomeVipWithReq:(BecomeVipReq *)req {
    [self startRequestWithParams:req.mj_keyValues];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = VIP_JOIN_URL;//APIURL(@"/butler-main/joinUser");
    return command;
}

@end
