//
//  CrowdfundingModel.h
//  Qqw
//
//  Created by zagger on 16/8/24.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  众筹商品结构
 */
@interface CrowdfundingModel : NSObject

@property (nonatomic, copy) NSString *cf_id;

@property (nonatomic, copy) NSString *cf_name;

@property (nonatomic, copy) NSString *sku_id;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *product;

@property (nonatomic, copy) NSString *pic_one;

@property (nonatomic, copy) NSString *pic_two;

@property (nonatomic, copy) NSString *cf_ret;

@property (nonatomic, copy) NSString *cf_money;

@property (nonatomic, copy) NSString *cf_days;

@property (nonatomic, copy) NSString *cf_detail;

@property (nonatomic, copy) NSString *cf_num;

@property (nonatomic, copy) NSString *cf_virtual_num;

@property (nonatomic, copy) NSString *cf_moneyed;

@property (nonatomic, copy) NSString *cf_back_id;

@property (nonatomic, copy) NSString *cf_status;

@property (nonatomic, copy) NSString *cf_reason;

@property (nonatomic, copy) NSString *cf_type;

@property (nonatomic, copy) NSString *is_delete;

@property (nonatomic, copy) NSString *is_top;

@property (nonatomic, copy) NSString *cf_time;

@property (nonatomic, copy) NSString *cf_check_time;

@property (nonatomic, copy) NSString *delivery;

@property (nonatomic, copy) NSString *zc_money;

@property (nonatomic, copy) NSString *back_title;

@property (nonatomic, copy) NSString *limit_people;

@property (nonatomic, copy) NSString *back_time;

@property(nonatomic,assign) BOOL is_limit;


@end
