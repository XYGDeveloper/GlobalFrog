//
//  CommentModel.h
//  Qqw
//
//  Created by 全球蛙 on 2016/12/16.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject



@property (nonatomic, copy)NSString *comment_id;
@property (nonatomic, copy)NSString *article_id;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *is_top;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,copy)NSString *info;
@property (nonatomic, copy)NSString *sort_order;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, copy)NSString *unread;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *face;

@end
