//
//  AppDelegate.h
//  DMMacEggTimer
//
//  Created by lbq on 2018/4/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,NSWindowDelegate>

- (void)enableMenusStart:(BOOL)start stop:(BOOL)stop reset:(BOOL)reset;
@end

