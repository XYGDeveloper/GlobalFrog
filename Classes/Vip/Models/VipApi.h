//
//  VipApi.h
//  Qqw
//
//  Created by zagger on 16/8/29.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

/**
 *  成为会员显示信息的数据结构
 *  price-价格 =0为免费  >0 需要缴费；content-提示内容；mobile-手机号码；ismember-是否会员 1-是 0-否
 */
@interface VipExplain : NSObject

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) BOOL ismember;

/**
 *  是否免费成为会员
 */
@property (nonatomic, assign, readonly) BOOL isFree;

@end



@interface VipApi : BaseApi

/**
 *  获取成为会员时，需要显示给用户的说明信息
 */
- (void)getVipExplain;

@end



/**
 *  成为会员请求需要的信息
 */
@interface BecomeVipReq : NSObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *invite_id;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *years;

@end


@interface BecomeVipApi : BaseApi

- (void)becomeVipWithReq:(BecomeVipReq *)req;

@end
