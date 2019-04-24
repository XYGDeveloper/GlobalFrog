//
//  CommentListApi.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/16.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "CommentListApi.h"
#import "CommentModel.h"
@implementation CommentListApi

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand getApiCommand];
    command.requestURLString = COMMENT_LIST_URL;//APIURL(@"/butler-article/commentList");
    return command;
    
}
- (id)reformData:(id)responseObject {
    
    NSArray *array = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
    return array;
    
}


@end
