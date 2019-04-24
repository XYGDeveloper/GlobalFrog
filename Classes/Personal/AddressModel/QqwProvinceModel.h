//
//  QqwProvinceModel.h
//  Qqw
//
//  Created by elink on 16/7/26.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

@protocol QqwCityModel  <NSObject>
@end

@interface QqwAreaModel : NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *postcode;


@end

@interface QqwCityModel : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSArray *areas;
@property(nonatomic,strong)NSString *postcode;

@end
@interface QqwProvinceModel : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *postcode;
@property(nonatomic,strong)NSArray *cities;
@end


