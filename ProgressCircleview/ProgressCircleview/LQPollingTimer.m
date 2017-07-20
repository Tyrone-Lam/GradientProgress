//
//  LQPollingTimer.m
//  parkingkeeper
//
//  Created by monkey on 2017/3/1.
//  Copyright © 2017年 luqiao. All rights reserved.
//

#import "LQPollingTimer.h"

@interface LQPollingTimer ()

@property (nonatomic, strong) dispatch_source_t time;

@end

@implementation LQPollingTimer

LQSingletonM(PollingTimer)

- (void)startTimerWithStartTime:(float)startTime withTimeInterval:(float)tInter withContinuedtime:(float)totalTime {
    
    if (self.time) {
        dispatch_cancel(self.time);
        self.time = nil;
    }
    
    __block int count = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(startTime * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(tInter * NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    WeakObj(self);
    dispatch_source_set_event_handler(self.time, ^{
        StrongObj(self);
        //设置当执行XX分钟后取消定时器
        count++;
        if (count == (int)(totalTime/tInter)) {
            dispatch_cancel(selfStrong.time);
            selfStrong.time = nil;
            //回主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfStrong.delegate theTimerTarget];
                if (selfStrong.delegate && [selfStrong respondsToSelector:@selector(didEndOfTimer)]) {
                    [selfStrong.delegate didEndOfTimer];
                }
            });
        }
        else {
            //回主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfStrong.delegate theTimerTarget];
            });
        }
        
    });
    
    //启动定时器
    dispatch_resume(self.time);
}

- (void)stopTimer {
    if (self.time) {
        dispatch_suspend(self.time);
    }
}

- (void)continueTimer {
    if (self.time) {
        dispatch_resume(self.time);
    }
}

- (void)deallocTimer {
    if (self.time) {
        if (self.delegate && [self respondsToSelector:@selector(didEndOfTimer)]) {
            [self.delegate didEndOfTimer];
        }
        dispatch_source_cancel(self.time);
    }
}

@end
