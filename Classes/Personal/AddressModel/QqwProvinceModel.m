//
//  QqwProvinceModel.m
//  Qqw
//
//  Created by elink on 16/7/26.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "QqwProvinceModel.h"

@implementation QqwAreaModel

@end

@implementation QqwProvinceModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cities":@"QqwCityModel"};
}

@end

@implementation QqwCityModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"areas":@"QqwAreaModel"};
}

@end
