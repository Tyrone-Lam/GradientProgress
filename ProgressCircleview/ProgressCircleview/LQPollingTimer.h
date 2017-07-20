//
//  LQPollingTimer.h
//  parkingkeeper
//
//  Created by monkey on 2017/3/1.
//  Copyright © 2017年 luqiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLMarco.h"

@protocol LQPollingTimerDelegate <NSObject>

- (void)theTimerTarget;

@optional

- (void)didEndOfTimer;

@end

@interface LQPollingTimer : NSObject

/**
 停止 Dispatch Timer 有两种方法，一种是使用 dispatch_suspend ，另外一种是使用 dispatch_source_cancel 。
 
 dispatch_suspend 严格上只是把 Timer 暂时挂起，它和 dispatch_resume 是一个平衡调用，两者分别会减少和增加 dispatch 对象的挂起计数。当这个计数大于 0 的时候，Timer 就会执行。在挂起期间，产生的事件会积累起来，等到 resume 的时候会融合为一个事件发送。
 
 需要注意的是，dispatch source 并没有提供用于检测 source 本身的挂起计数的 API，也就是说外部不能得知一个 source 当前是不是挂起状态，在设计代码逻辑时需要考虑到这一点。
 
 dispatch_source_cancel 则是真正意义上的取消 Timer。被取消之后如果想再次执行 Timer，只能重新创建新的 Timer。这个过程类似于对 NSTimer 执行 invalidate 。
 
 关于取消 Timer，另外一个 很重要 的注意事项， dispatch_suspend 之后的 Timer，是不能被释放的！下面的代码会引起崩溃：
 - (void)stopTimer
 {
    dispatch_suspend(_timer);
    _timer = nil; // EXC_BAD_INSTRUCTION 崩溃
 }
 
 因此使用 dispatch_suspend 时，Timer 本身的实例需要一直保持。使用 dispatch_source_cancel 则没有这个限制：
 - (void)stopTimer
 {
    dispatch_source_cancel(_timer);
    _timer = nil; // 不会崩溃
 }
 */
LQSingletonH(PollingTimer)

@property (weak, nonatomic) id<LQPollingTimerDelegate> delegate;

- (void)startTimerWithStartTime:(float)startTime withTimeInterval:(float)tInter withContinuedtime:(float)totalTime;

/** dispatch_suspend 之后的 Timer，是不能被释放的！使用这个方法需要注意*/
//- (void)stopTimer;

- (void)continueTimer;

- (void)deallocTimer;

@end
