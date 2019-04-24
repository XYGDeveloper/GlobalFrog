//
//  AttentionModel.h
//  Qqw
//
//  Created by 全球蛙 on 2016/12/13.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionModel : NSObject

@property (nonatomic,copy)NSString *nickname;

@property (nonatomic,copy)NSString *face;

@property (nonatomic,copy)NSString *uid;

@property (nonatomic,copy)NSString *directions;

@property (nonatomic,copy)NSString *goods;

+(void)requestAttentuonWithFuid:(NSString*)fuid type:(int)type superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock ;

+(void)requestAttentuonListWithDataArray:(NSMutableArray*)dataArray page:(int)page superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock ;


@end
