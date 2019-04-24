//
//  ShopModel.h
//  Qqw
//
//  Created by 全球蛙 on 16/8/20.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject


@property (nonatomic,copy)NSString *favorite_id;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *create_time;
@property (nonatomic,copy)NSString *is_delete;
@property (nonatomic,copy)NSString *goods_name;
@property (nonatomic,copy)NSString *shop_price;
@property (nonatomic,copy)NSString *market_price;
@property (nonatomic,copy)NSString *goods_thumb;
@property (nonatomic,copy)NSString *face;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *lv;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *goods_id;
@property (nonatomic,copy)NSString *is_crowd;

+(void)requestShopWithGoodsId:(NSString*)goodsid type:(int)type superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock ;

+(void)requestShopListWithDataArray:(NSMutableArray*)dataArray page:(int)page superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock ;

@end
