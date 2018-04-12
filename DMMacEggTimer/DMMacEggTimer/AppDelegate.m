//
//  AppDelegate.m
//  DMMacEggTimer
//
//  Created by lbq on 2018/4/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSMenuItem *startTimerMenuItem;
@property (weak) IBOutlet NSMenuItem *stopTimerMenuItem;
@property (weak) IBOutlet NSMenuItem *resetTimerMenuItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)enableMenusStart:(BOOL)start stop:(BOOL)stop reset:(BOOL)reset
{
    self.startTimerMenuItem.enabled = start;
    self.stopTimerMenuItem.enabled = stop;
    self.resetTimerMenuItem.enabled = reset;
}

-(BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    if (!flag){//为了让close后的window，点dock中应用图标显示出来
        NSStoryboard *sb = [NSStoryboard mainStoryboard];
        NSWindowController *windowController = [sb instantiateInitialController];
        [windowController.window makeKeyAndOrderFront:self];
        return YES;
    }
    return NO;
}
@end
