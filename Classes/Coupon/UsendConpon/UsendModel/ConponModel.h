//
//  ConponModel.h
//  Qqw
//
//  Created by 全球蛙 on 16/8/24.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CouponTableViewController.h"

@interface ConponModel : NSObject

/**
 *  优惠券
 */
@property (nonatomic, copy) NSString *coupon_id;
@property (nonatomic,copy)NSString *is_enabled;
@property (nonatomic,copy)NSString *user_get_num;
@property (nonatomic,copy)NSString *instr;
@property (nonatomic,copy)NSString *get_type;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *total;
@property (nonatomic,copy)NSString *create_time;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *act_range_ext;
@property (nonatomic,copy)NSString *code_sn;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *act_range;
@property (nonatomic,copy)NSString *conditions;
@property (nonatomic,copy)NSString *time_text;
@property (nonatomic,copy)NSString *rang_type;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *discount_id;
@property (nonatomic,copy)NSString *get_time;
@property (nonatomic,copy)NSString *channel_id;
@property (nonatomic,copy)NSString *start_time;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic,copy)NSString *end_time;
@property (nonatomic,copy)NSString *export_num;
@property (nonatomic,copy)NSString *is_generated;
@property (nonatomic,copy)NSString *worth;

@property (nonatomic, copy) NSString *use_time;

@property (nonatomic, copy) NSString *currentRuleStr;
@property (nonatomic, copy) NSString *currentRangeStr;

+(void)requestConponWithDataArray:(NSMutableArray*)dataArray type:(CouponType)type page:(int)page superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;


@end
