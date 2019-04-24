//
//  DistriButePictureApi.m
//  Qqw
//
//  Created by 全球蛙 on 2017/1/10.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "DistriButePictureApi.h"

@implementation DistriButePictureApi


//评论接口
- (void)toDistubuteWithTid:(NSString *)tid
                   content:(NSString *)content{

    NSDictionary *parameter = @{
                                @"tid": tid ?: @"",
                                @"content": content ?: @"",
                                };
    [self startRequestWithParams:parameter];
    
}



- (void)toDistributePicWithCid:(NSString *)Cid content:(NSString *)content picture:(NSString *)picture
{
    
    NSDictionary *parameter = @{
                                @"cid": Cid ?: @"",
                                @"content": content ?: @"",
                                @"picture":picture ?:@"",
                                };
    [self startRequestWithParams:parameter];
    
    
}

//晒图接口

- (void)toDistributePicWithTid:(NSString *)tid content:(NSString *)content picture:(NSString *)picture
{
 
    NSDictionary *parameter = @{
                                @"tid": tid ?: @"",
                                @"content": content ?: @"",
                                @"picture":picture ?:@"",
                                };
    [self startRequestWithParams:parameter];
    
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"/topic-main/comment");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    return responseObject;
    
}

@end
