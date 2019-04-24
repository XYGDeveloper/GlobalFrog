//
//  SortListItem.h
//  Qqw
//
//  Created by zagger on 16/8/31.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  分类列表模型
 */
@interface SortListItem : NSObject

@property (nonatomic, copy) NSString *cat_id;

@property (nonatomic, copy) NSString *cat_name;

@property (nonatomic, copy) NSString *cat_img;

@property (nonatomic, strong) NSArray *child;

@end
