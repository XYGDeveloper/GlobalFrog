//
//  RealListModel.h
//  Qqw
//
//  Created by 全球蛙 on 2017/1/5.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealListModel : NSObject

@property (nonatomic, copy)NSString *rID;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *realname;
@property (nonatomic, copy)NSString *face;
@property (nonatomic, copy)NSString *back;
@property (nonatomic, copy)NSString *card_number;
@property (nonatomic, copy)NSString *is_default;

+(void)requestRealListWithSuperView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

+(void)requestEditRealWithId:(NSString*)rID type:(int)type superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

@end
