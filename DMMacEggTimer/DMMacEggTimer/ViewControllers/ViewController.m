//
//  ViewController.m
//  DMMacEggTimer
//
//  Created by lbq on 2018/4/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "ViewController.h"
#import "DMEggTimer.h"
#import "AppDelegate.h"
#import "DMPreferences.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController()<DMEggTimerProtocol>
@property (weak) IBOutlet NSTextField *timeLeftField;
@property (weak) IBOutlet NSImageView *eggImageView;
@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSButton *stopButton;
@property (weak) IBOutlet NSButton *resetButton;
@property (nonatomic, strong) DMPreferences *prefs;
@property (nonatomic, strong) DMEggTimer *eggTimer;

@property (nonatomic, strong) AVAudioPlayer *soundPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.prefs = [DMPreferences new];
    self.eggTimer = [[DMEggTimer alloc] init];
    self.eggTimer.delegate = self;
    
    [self setupPrefs];
    // Do any additional setup after loading the view.
}

- (void)prepareSound
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ding" withExtension:@"mp3"];
    NSError *error;
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [self.soundPlayer prepareToPlay];
}

- (void)playSound
{
    [self.soundPlayer play];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)setupPrefs
{
    [self updateDisplayForTime:self.prefs.selectedTime];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForResetAfterPrefsChange) name:@"PrefsChanged" object:nil];
}

- (void)updateFromPrefs
{
    self.eggTimer.duration = self.prefs.selectedTime;
    [self resetButtonClicked:self];
}

- (void)checkForResetAfterPrefsChange
{
    if (self.eggTimer.isStopped || self.eggTimer.isPaused) {
        [self updateFromPrefs];
    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Reset timer with the new settings?";
        alert.informativeText = @"This will stop your current timer!";
        alert.alertStyle = NSAlertStyleWarning;
        
        [alert addButtonWithTitle:@"Reset"];
        [alert addButtonWithTitle:@"Cancel"];
        
        NSModalResponse response = [alert runModal];
        if (response == NSAlertFirstButtonReturn) {
            [self updateFromPrefs];
        }
    }
}

- (void)configureButtonsAndMenus
{
    BOOL enableStart;
    BOOL enableStop;
    BOOL enableReset;
    
    if (self.eggTimer.isStopped) {
        enableStart = YES;
        enableStop = NO;
        enableReset = NO;
    } else if (self.eggTimer.isPaused) {
        enableStart = YES;
        enableStop = NO;
        enableReset = YES;
    } else {
        enableStart = NO;
        enableStop = YES;
        enableReset = NO;
    }
    
    self.startButton.enabled = enableStart;
    self.stopButton.enabled = enableStop;
    self.resetButton.enabled = enableReset;
    
    AppDelegate *appDel = (AppDelegate *)([NSApplication sharedApplication].delegate);
    
    [appDel enableMenusStart:enableStart stop:enableStop reset:enableReset];
}

- (void)updateDisplayForTime:(NSTimeInterval)timeRemaining
{
    self.timeLeftField.stringValue = [self textToDisplayForTime:timeRemaining];
    self.eggImageView.image = [self imageToDisplayForTime:timeRemaining];
}

- (NSString *)textToDisplayForTime:(NSTimeInterval)timeRemaining
{
    if (timeRemaining == 0) {
        return @"Done!";
    }
    
    NSTimeInterval minutesRemaining = floor(timeRemaining / 60);
    NSTimeInterval secondsRemaining = timeRemaining - minutesRemaining * 60;
    
    NSString *secondDisplay = [NSString stringWithFormat:@"%02tu",(NSInteger)secondsRemaining];
    NSString *timeRemainingDisplay = [NSString stringWithFormat:@"%tu:%@",(NSInteger)minutesRemaining,secondDisplay];
    return timeRemainingDisplay;
}

- (NSImage *)imageToDisplayForTime:(NSTimeInterval) timeRemaining{
    NSTimeInterval percentageComplete = 100 - (timeRemaining / 360 * 100);
    if (self.eggTimer.isStopped) {
        NSString *stoppedImageName = timeRemaining == 0 ? @"100" : @"stopped";
        return [NSImage imageNamed:stoppedImageName];
    }

    NSString * imageName;
    if(percentageComplete > 0 && percentageComplete < 25){
        imageName = @"0";
    } else if (percentageComplete >= 25 && percentageComplete < 50){
        imageName = @"25";
    } else if (percentageComplete >= 50 && percentageComplete < 75){
        imageName = @"50";
    } else if (percentageComplete >= 75 && percentageComplete < 100){
        imageName = @"75";
    } else {
        imageName = @"100";
    }
    return [NSImage imageNamed:imageName];
}

//MARK: Clicked
- (IBAction)startButtonClicked:(id)sender {
    if (self.eggTimer.isPaused) {
        [self.eggTimer resumeTimer];
    } else {
        self.eggTimer.duration = self.prefs.selectedTime;
        [self.eggTimer startTimer];
        [self prepareSound];
    }
    [self configureButtonsAndMenus];
}
- (IBAction)stopButtonClicked:(id)sender {
    [self.eggTimer stopTimer];
    [self configureButtonsAndMenus];
}
- (IBAction)resetButtonClicked:(id)sender {
    [self.eggTimer resetTimer];
    [self updateDisplayForTime:self.prefs.selectedTime];
    [self configureButtonsAndMenus];
}

- (IBAction)startTimerMenuItemSelected:(id)sender {
    [self startButtonClicked:sender];
}

- (IBAction)stopTimerMenuItemSelected:(id)sender {
    [self stopButtonClicked:sender];
}

- (IBAction)resetTimerMenuItemSelected:(id)sender {
    [self resetButtonClicked:sender];
}

//MARK: DMEggTimerProtocol
- (void)timerHasFinished:(DMEggTimer *)timer
{
    [self playSound];
    [self updateDisplayForTime:0];
    [self configureButtonsAndMenus];
}

- (void)timeRemainingOnTimer:(DMEggTimer *)timer timeRemaining:(NSTimeInterval)timeRemaining
{
    [self updateDisplayForTime:timeRemaining];
}
@end
