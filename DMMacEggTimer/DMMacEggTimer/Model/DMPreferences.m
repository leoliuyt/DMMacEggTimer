//
//  DMPreferences.m
//  DMMacEggTimer
//
//  Created by lbq on 2018/4/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "DMPreferences.h"

@implementation DMPreferences

- (void)setSelectedTime:(NSTimeInterval)selectedTime
{
    [[NSUserDefaults standardUserDefaults] setDouble:selectedTime forKey:@"selectedTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSTimeInterval)selectedTime
{
    NSTimeInterval savedTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"selectedTime"];
    return savedTime > 0 ? savedTime : 360;
}

@end
