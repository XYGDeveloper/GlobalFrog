//
//  ShareApi.m
//  Qqw
//
//  Created by zagger on 16/8/26.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ShareApi.h"

@implementation ShareApi

- (void)getShareInfoWithType:(NSString *)shareType
                     shareTo:(NSString *)shareTo
                  identifier:(NSString *)shareId {
    
    NSDictionary *params = @{@"type": shareType ?: @"",
                             @"id" : shareId ?: @"",
                             @"shareTo":shareTo ?:@""
                             };
    
    [self startRequestWithParams:params];
    
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.method = QQWRequestMethodGet;
    command.requestURLString = SHARE_URL;//APIURL(@"/share/get");
    return command;
}

- (id)reformData:(id)responseObject {
    NSLog(@"分享参数：%@",responseObject);
    ShareModel *model = [ShareModel mj_objectWithKeyValues:responseObject];
    return model;
}

@end
