//
//  TopicItem.h
//  Qqw
//
//  Created by zagger on 16/9/1.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  精选专题
 */
@interface TopicItem : NSObject

@property (nonatomic, copy) NSString *cate_id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *images;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, copy) NSString *logo_name;

@property (nonatomic, copy) NSString *slogan;

@property (nonatomic, copy) NSString *article_num;

@property (nonatomic, copy) NSString *follows;


@end
