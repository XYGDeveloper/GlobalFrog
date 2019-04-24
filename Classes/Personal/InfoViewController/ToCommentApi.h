//
//  ToCommentApi.h
//  Qqw
//
//  Created by 全球蛙 on 2016/12/16.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

@interface ToCommentApi : BaseApi

- (void)toCommitCommentWithId:(NSString *)arctile_id contentStr:(NSString *)content;

@end
