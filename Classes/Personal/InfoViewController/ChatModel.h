//
//  MyInfoViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *suid;
@property (nonatomic, copy)NSString *snickname;
@property (nonatomic, copy)NSString *sface;
@property (nonatomic, copy)NSString *touid;
@property (nonatomic,copy)NSString *tonickname;
@property (nonatomic,copy)NSString *toface;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *dateline;

@property (nonatomic,assign) BOOL isRight;

+(void)requestSendMSGWithMsg:(NSString*)msg uid:(NSString*)uid superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

+(void)requestMsgListWithMid:(NSString*)mid uid:(NSString*)uid page:(int)page dataArray:(NSMutableArray*)dataArray superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock;

@end
