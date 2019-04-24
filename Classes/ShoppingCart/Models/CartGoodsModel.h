//
//  CartGoodsModel.h
//  Qqw
//
//  Created by zagger on 16/8/17.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "ShowTimeInfo.h"
@class CartAttrValue;

/**
 *  购物车中的商品结构
 */
@interface CartGoodsModel : NSObject

@property (nonatomic, copy) NSString *sku_id;

@property (nonatomic, copy) NSString *product_id;

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *sale_price;

@property (nonatomic, copy) NSString *market_price;

@property (nonatomic, copy) NSString *attr_img;

@property (nonatomic, copy) NSString *sku_sn;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *goods_thumb;

@property (nonatomic, copy) NSString *brand_id;

@property (nonatomic, copy) NSString *cat_id;

@property (nonatomic, copy) NSString *rtype;

@property (nonatomic, copy) NSString *attr_id;

@property (nonatomic, strong) NSArray *attr_value;

@property (nonatomic, copy) NSString *attr_value_format;

@property (nonatomic, copy) NSString *mod_number;

@property (nonatomic, copy) NSString *goods_number;

@property (nonatomic, copy) NSString *cart_id;

@property (nonatomic, strong) NSArray *gift;

@property(nonatomic,assign) BOOL is_limit;

/** 商品总价格，数量*单价 */
- (CGFloat)goodsTotalAmount;




@end

@interface CartAttrValue : NSObject

@property (nonatomic, copy) NSString *attr_id;

@property (nonatomic, copy) NSString *attr_name;

@property (nonatomic, copy) NSString *attr_value_id;

@property (nonatomic, copy) NSString *attr_value;

@end



@interface CartGroupItem : NSObject

@property (nonatomic, strong) NSArray *activityInfo;

@property (nonatomic, strong) NSArray *goodsList;

/*  new  */
@property(nonatomic,strong) NSString * name;
@property(nonatomic,assign) int rtype; //0-平台直供 1-工厂 2-保税区 4-生鲜
@property(nonatomic,strong) NSString * shipping;
@property (nonatomic, strong) NSArray *list;
@property(nonatomic,assign) float shipping_fee;

@property(nonatomic,assign) BOOL showtime;  // 是否显示送到时间 1-是 0-否
@property (nonatomic, strong) NSArray *timelist;
@property(nonatomic,strong) NSString * time;
@property (nonatomic, copy) NSString *packingFee; //包装费

@property(nonatomic,strong) NSString * remark;

@property(nonatomic,assign) float nowMoney;




@end


/**
 *  购物车中商品总信息
 */
@interface CartGoodsInfo : NSObject

@property (nonatomic, strong) NSArray *cartGoodsList;

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, copy) NSString *orderPayAmount;

@property (nonatomic, copy) NSString *activityAmount;

@property (nonatomic, copy) NSString *cartGoodsNumber;

@property (nonatomic,copy)NSString *endtime;

@property (nonatomic, strong) NSArray *goods;

@property(nonatomic,assign) float shipping_fee;
@property(nonatomic,strong) NSString * shipping_msg;


+(void)requestCarListWithSuperView:(UIView*)superView finshBlock:(void (^)(CartGoodsInfo * obj,NSError * error))finshBlock;

+(void)requestEditCarWithCarId:(NSString*)carid number:(int)num superView:(UIView*)superView finshBlock:(void (^)(id obj,NSError * error))finshBlock;

+(void)requestDeletCarWithGoods:(NSArray *)goodsArray superView:(UIView*)superView finshBlock:(void (^)(id obj,NSError * error))finshBlock;

+(void)requestIsRealNameAuthWithGoods:(NSString *)goodsArray superView:(UIView*)superView finshBlock:(void (^)(id obj,NSError * error))finshBlock;

@end


