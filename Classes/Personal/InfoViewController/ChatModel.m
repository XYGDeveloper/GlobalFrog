//
//  MyInfoViewController.m
//  Qqw
//
//  Created by 全球蛙 on 2016/12/8.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

- (instancetype)init{
    self  = [super init];
    if (self) {
        self.isRight = NO;
    }
    return self;
}

+(void)requestSendMSGWithMsg:(NSString *)msg uid:(NSString *)uid superView:(UIView *)superView finshBlock:(void (^)(id, NSError *))finshBlock{
    [MyRequestApiClient requestPOSTUrl:MSG_SEND_URL parameters:@{@"touid": uid,@"msg": msg} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            finshBlock(nil,nil);
        }
    }];
}

+(void)requestMsgListWithMid:(NSString*)mid uid:(NSString*)uid page:(int)page dataArray:(NSMutableArray*)dataArray superView:(UIView*)superView finshBlock:(void (^)(id  obj,NSError * error))finshBlock{
    [MyRequestApiClient requestGETUrl:MSG_DETAIL_URL parameters:@{@"touid": uid,@"id": mid,@"p":@(page)} superView:superView finshBlock:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [dataArray removeAllObjects];
            NSMutableArray * a = [ChatModel mj_objectArrayWithKeyValuesArray:obj[@"list"]];
            NSEnumerator *enumerator = [a reverseObjectEnumerator];
            [dataArray addObjectsFromArray:[enumerator allObjects]] ;
            finshBlock(nil,nil);
        }
    }];
    
}

@end
