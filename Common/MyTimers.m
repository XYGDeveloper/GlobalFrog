//
//  MyTimers.m
//  Qqw
//
//  Created by 全球蛙 on 2017/3/21.
//  Copyright © 2017年 quanqiuwa. All rights reserved.
//

#import "MyTimers.h"

@implementation MyTimers

//+(instancetype)sharedTimers{
//    static MyTimers * _myTimers = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _myTimers = [MyTimers new];
//    });
//    return _myTimers;
//}

-(void)canceTime{
    if (self.timer) {
        dispatch_cancel(self.timer);
    }
}
-(void)startTimersWithTime:(NSInteger)timeInterval block:(TimerBlock)timerBlock{
    _timeInterval = timeInterval;
    if (timeInterval ==0) {
        if (self.timer) {
            dispatch_cancel(self.timer);
        }
        timerBlock(@"");
        return;
    }
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
   
    if (self.timer) {
        dispatch_cancel(self.timer);
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    dispatch_source_set_event_handler(self.timer, ^{
        _timeInterval--;
        int seconds = _timeInterval % 60;
        int minutes = (_timeInterval / 60) % 60;
   
        NSString * time = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        
        if (_timeInterval == 0) {
            dispatch_cancel(self.timer);
            self.timer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                timerBlock(@"");
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                timerBlock(time);
            });
            
        }
    });
    
    dispatch_resume(self.timer);
}


@end
