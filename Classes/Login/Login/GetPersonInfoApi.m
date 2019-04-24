//
//  GetPersonInfoApi.m
//  Qqw
//
//  Created by XYG on 16/10/25.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "GetPersonInfoApi.h"

@implementation GetPersonInfoApi

- (void)userInfoWithNikeName:(NSString *)nikeName sex:(NSString *)sex face:(NSString *)face province:(NSString *)province city:(NSString *)city distrction:(NSString *)district registerId:(NSString *)registerId
{
    
    NSDictionary *params = @{
                             @"nickname": nikeName ?:@"",
                             @"sex": sex ?:@"",
                             @"face": face ?:@"",
                             @"province": province ?:@"",
                             @"city": city ?:@"",
                             @"district": district ?:@"",
                             @"registerID":registerId ?:@"",
                             @"os":@"iOS",
                             @"version":[UIDevice currentDevice].systemVersion ?:@"",
                             };
    
    [self startRequestWithParams:params];
    
}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = CHANGE_USER_INFO_URL;
    return command;
}

- (id)reformData:(id)responseObject {
    
    NSLog(@"个人资料：%@",responseObject);
    return responseObject;
}



@end
