//
//  AddressModel.m
//  Qqw
//
//  Created by XYG on 16/7/27.
//  Copyright © 2016年 gao.jian. All rights reserved.
//

#import "AddressModel.h"
#import "MyRequestApiClient.h"
@implementation AddressModel

- (NSString *)fullAddress {
    return [NSString stringWithFormat:@"%@%@%@%@%@",self.province?: @"",self.city?: @"",self.district?: @"",self.area?: @"",self.details?:@""];
}

- (NSString *)areaDisplayString {
    return [NSString stringWithFormat:@"%@ %@ %@",self.province?: @"",self.city?: @"",self.district?: @""];
}
//
//-(void)setDetails:(NSString *)details{
//    _details = details;
//    NSLog(@"%@   %@",_area,details);
//}

+(void)requestUpdateAddressInfoWithAddress:(AddressModel*)address type:(int)type superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    NSString * url;
    NSMutableDictionary * dic = address.mj_keyValues;
    switch (type) {
        case 0:
            url = UPDATE_ADDRESS_URL;
            break;
         case 1:
            url = DEL_ADDRESS_URL;
            break;
        case 2:
            url = ADD_ADDRESS_URL;
        
            break;
        case 3:
            url = UPDATA_FRESH_ADDRESS_URL;
            break;
        case 4:
            url = ADD_FRESH_ADDRESS_URL;
            [dic removeObjectForKey:@"fullAddress"];
            [dic removeObjectForKey:@"areaDisplayString"];
            break;
        default:
            break;
    }
    
    [MyRequestApiClient requestPOSTUrl:url parameters:dic superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(nil,nil);
        }
    }];
}

+(void)requestAddressListWithPage:(int)page dataArray:(NSMutableArray *)dataArray superView:(UIView *)superView finshBlock:(void (^)(id, NSError *))finshBlock{
    [MyRequestApiClient requestPOSTUrl:ADDRESS_LIST_URL parameters:@{@"page": @(page),@"psize":@10} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            
            if (page == 1) {
                [dataArray removeAllObjects];
            }
            if ([obj isKindOfClass:[NSArray class]]) {
                for (NSDictionary * dic  in obj) {
                    AddressModel * a = [AddressModel mj_objectWithKeyValues:dic];
                    if ([a.details rangeOfString:a.area].length>0) {
                        a.details = [a.details substringFromIndex:a.area.length];
                    }
                    [dataArray addObject:a];
                }
            }
           
//            [dataArray addObjectsFromArray:[AddressModel mj_objectArrayWithKeyValuesArray:obj]];
            finshBlock(nil,nil);
        }else{
            finshBlock(nil,error);
        }
        
        
    }];
}

@end
