//
//  MyTimers.h
//  Qqw
//
//  Created by 全球蛙 on 2017/3/21.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimerBlock)(NSString * time);
@interface MyTimers : NSObject{
    int _tmpCount;

}

@property (nonatomic, strong) dispatch_source_t timer;

@property(nonatomic,assign) NSInteger timeInterval;

//+ (instancetype)sharedTimers;

-(void)canceTime;

-(void)startTimersWithTime:(NSInteger)timeInterval block:(TimerBlock)timerBlock;


@end
