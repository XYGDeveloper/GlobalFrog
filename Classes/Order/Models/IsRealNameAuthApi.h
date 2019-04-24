//
//  IsRealNameAuthApi.h
//  Qqw
//
//  Created by 全球蛙 on 2017/1/6.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "BaseApi.h"

@interface IsRealNameAuthApi : BaseApi

/*
 *判断是否经过了实名认证
 * @parameter：goods_id_list：商品id列表 格式 141324,5454,2321,4444 错误格式：134123，,242,42314，(结尾或者开头不要有逗号)
 * @return ：返回值：result： rusult = 0 已经实名认证过（ret = 0）
 *               rusult = 1 需要实名认证（ret = 0） 填写认证信息：/user-idcard/add 提交
 */

- (void)toJudgeIsRealNameAuthWithGoods_id_list:(NSString *)goods_id_list;

@end
