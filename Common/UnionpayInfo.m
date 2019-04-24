//
//  UnionpayInfo.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/22.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "UnionpayInfo.h"
#import "PayModeItem.h"
#import "FinanceManager.h"

@implementation UnionpayInfo

+(void)requestPayInfoWithOrderNumber:(NSString *)orderNo payMode:(NSString *)payMode superView:(UIView *)superView finshBlock:(void (^)(UnionpayInfo *, NSError *))finshBlock{
    
    NSDictionary *params = @{@"pay_id": (payMode ?: PayModeWechat),//支付方式
                             @"order_sn": orderNo ?: @"",//订单号
                             @"bank_code": @"",//客户端
                             @"type":@"0" //类型为8为众筹，0为普通
                             };
    
    [MyRequestApiClient requestPOSTUrl:PAY_INFO_URL parameters:params superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            NSString * str = obj[@"pay_parmas"] ;
          
       
            if ([obj[@"pay_id"] isEqualToString:@"1"]) {
                [[FinanceManager sharedFInanceManager]alipay:str callback:^(BOOL success, NSString *err) {
                    if (!success) {
                         [Utils showErrorMsg:[AppDelegate APP].window type:0 msg:err];
                    }
                }];
            }else if ([obj[@"pay_id"] isEqualToString:@"5"]){
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dic;
                if (data) {
                    dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
                }
                WXPayReq *w = [WXPayReq mj_objectWithKeyValues:dic];
                [[FinanceManager sharedFInanceManager]wxpay:w viewCtr:nil callback:^(BOOL success, NSString *err) {
                        
                }];
            }
        }
        
    }];
    
}

@end
