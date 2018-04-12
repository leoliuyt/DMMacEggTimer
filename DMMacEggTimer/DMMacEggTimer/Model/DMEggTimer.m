//
//  DMEggTimer.m
//  DMMacEggTimer
//
//  Created by lbq on 2018/4/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "DMEggTimer.h"
@interface DMEggTimer()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *startTime;

@property (nonatomic, assign) NSTimeInterval elapsedTime;
@end
@implementation DMEggTimer

- (BOOL)isStopped
{
    return self.timer == nil && self.elapsedTime == 0;
}

- (BOOL)isPaused
{
    return self.timer == nil && self.elapsedTime > 0;
}

- (void)timerAction
{
    if (!self.startTime) {return;}
    
    self.elapsedTime = - self.startTime.timeIntervalSinceNow;
    
    NSTimeInterval secondsRemaining = round(self.duration - self.elapsedTime);
    if (secondsRemaining <= 0) {
        [self resetTimer];
        [self.delegate timerHasFinished:self];
    } else {
        [self.delegate timeRemainingOnTimer:self timeRemaining:secondsRemaining];
    }
}

- (void)startTimer
{
    self.startTime = [NSDate date];
    self.elapsedTime = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self timerAction];
}

- (void)resumeTimer
{
    self.startTime = [NSDate dateWithTimeIntervalSinceNow:-self.elapsedTime];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self timerAction];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    [self timerAction];
}

- (void)resetTimer
{
    [self.timer invalidate];
    self.timer = nil;
    
    self.startTime = nil;
    self.duration = 360;
    self.elapsedTime = 0;
    [self timerAction];
}
@end
