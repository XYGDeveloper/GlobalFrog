//
//  DoyenListItem.h
//  Qqw
//
//  Created by zagger on 16/8/30.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DiscoverTopicItem;

/**
 *  发现达人列表
 */
@interface DoyenListItem : NSObject

@property (nonatomic, copy) NSString *doyen_type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *list;




@end


/**
 *  达人基本信息
 */
@interface DoyenItem : NSObject

@property (nonatomic, copy) NSString *doyen_id;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *face;

@property (nonatomic, copy) NSString *show_picture;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *slogan;

@property (nonatomic, copy) NSString *article_num;

@property (nonatomic, copy) NSString *doyen_type;

@property (nonatomic, copy) NSString *is_delete;

@property (nonatomic, copy) NSString *isFollow;

@property (nonatomic, copy) NSString *follows;

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong)DoyenItem *item;
@end
