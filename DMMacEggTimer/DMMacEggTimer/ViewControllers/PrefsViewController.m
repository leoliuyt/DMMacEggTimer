//
//  PrefsViewController.m
//  DMMacEggTimer
//
//  Created by lbq on 2018/4/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "PrefsViewController.h"
#import "DMPreferences.h"
@interface PrefsViewController ()
@property (weak) IBOutlet NSPopUpButton *presetsPopup;
@property (weak) IBOutlet NSSlider *customSlider;
@property (weak) IBOutlet NSTextField *customTextField;

@property (nonatomic, strong) DMPreferences *prefs;

@end

@implementation PrefsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.prefs = [[DMPreferences alloc] init];
    [self showExistingPrefs];
}

- (void)showExistingPrefs
{
    NSTimeInterval selectedTimeMinutes = self.prefs.selectedTime / 60;
    [self.presetsPopup selectItemWithTitle:@"Custom"];
    self.customSlider.enabled = YES;
    
    [self.presetsPopup.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == selectedTimeMinutes) {
            [self.presetsPopup selectItem:obj];
            self.customSlider.enabled = NO;
            *stop = YES;
        }
    }];
    
    self.customSlider.integerValue = selectedTimeMinutes;
    [self showSliderValueAsText];
}

- (void)showSliderValueAsText
{
    NSInteger newTimerDuration = self.customSlider.integerValue;
    NSString *minutesDes = newTimerDuration == 1 ? @"minute" : @"minutes";
    self.customTextField.stringValue = [NSString stringWithFormat:@"%tu %@",newTimerDuration,minutesDes];
}

- (void)saveNewPrefs
{
    self.prefs.selectedTime = self.customSlider.doubleValue * 60;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PrefsChanged" object:nil];
}

//MARK: action
- (IBAction)popupValueChanged:(NSPopUpButton *)sender {
    if ([sender.selectedItem.title isEqualToString:@"Custom"]) {
        self.customSlider.enabled = YES;
        return;
    }
    NSInteger newTimeDuration = sender.selectedTag;
    self.customSlider.integerValue = newTimeDuration;
    [self showSliderValueAsText];
    self.customSlider.enabled = NO;
}

- (IBAction)sliderValueChanged:(id)sender {
    [self showSliderValueAsText];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.view.window close];
}

- (IBAction)okButtonClicked:(id)sender {
    [self saveNewPrefs];
    [self.view.window close];
}



@end
