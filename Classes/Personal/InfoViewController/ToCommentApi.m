//
//  ToCommentApi.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/16.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ToCommentApi.h"

@implementation ToCommentApi


- (void)toCommitCommentWithId:(NSString *)arctile_id contentStr:(NSString *)content
{
    
    NSDictionary *params = @{@"id": arctile_id ?:@"",
                             @"content": content ?:@""
                             
                             };
    
    [self startRequestWithParams:params];

}



- (ApiCommand *)buildCommand {
    
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = COMMENT_SAVE_URL;//APIURL(@"/butler-article/saveComment");
    
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    return responseObject;
    
}

@end
