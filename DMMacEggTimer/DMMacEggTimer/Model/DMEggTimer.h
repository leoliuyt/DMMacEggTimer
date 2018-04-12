//
//  DMEggTimer.h
//  DMMacEggTimer
//
//  Created by lbq on 2018/4/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DMEggTimer;
@protocol DMEggTimerProtocol

- (void)timeRemainingOnTimer:(DMEggTimer *)timer timeRemaining:(NSTimeInterval)timeRemaining;
- (void)timerHasFinished:(DMEggTimer *)timer;

@end

@interface DMEggTimer : NSObject
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign, getter=isStopped) BOOL stopped;
@property (nonatomic, assign, getter=isPaused) BOOL paused;
@property (nonatomic, weak) id<DMEggTimerProtocol> delegate;

- (void)startTimer;
- (void)resumeTimer;
- (void)stopTimer;
- (void)resetTimer;
@end
