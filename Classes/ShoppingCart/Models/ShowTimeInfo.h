//
//  ShowTimeInfo.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/23.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowTimeInfo : NSObject

@property(nonatomic,strong) NSString * name;

@property(nonatomic,strong) NSArray * list;

@property(nonatomic,assign) float packingFee; //包装费 >0 显示

@end

@interface TimeInfo : NSObject

@property(nonatomic,strong) NSString * time;
@property(nonatomic,strong) NSString * show;

@end
