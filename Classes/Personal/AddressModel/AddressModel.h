//
//  AddressModel.h
//  Qqw
//
//  Created by XYG on 16/7/27.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
/**
 *  添加地址部分
 *  @para 联系人姓名
 *  @para 联系电话
 *  @para 省，市，区
 *  @para 是否设为默认地址
 */

@property (nonatomic, copy) NSString *consignee;//收件人

@property (nonatomic, copy) NSString *address_id;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *province_code;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *city_code;

@property (nonatomic, copy) NSString *district;

@property (nonatomic, copy) NSString *district_code;

@property (nonatomic, copy) NSString *details;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) BOOL is_default;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, copy) NSString *area;


/**
 *  返回完整的地址信息，如：广东省深圳市南山区高新南一道3号
 */
@property (nonatomic, copy, readonly) NSString *fullAddress;

/**
 *  省、市、区拼接字符串
 */
@property (nonatomic, copy, readonly) NSString *areaDisplayString;


+(void)requestUpdateAddressInfoWithAddress:(AddressModel*)address type:(int)type superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock ;

+(void)requestAddressListWithPage:(int)page dataArray:(NSMutableArray*)dataArray superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;


@end
