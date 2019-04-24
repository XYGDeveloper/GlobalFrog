//
//  PrivateMsgModel.h
//  Qqw
//
//  Created by 全球蛙 on 2016/12/14.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

//聊天用户（主方信息）
@interface PrivateMsgModel : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *face;

@property (nonatomic, copy) NSString *newnum;

@property (nonatomic, copy) NSString *dateline;

@property (nonatomic, copy) NSString *lastmsg;

@end
