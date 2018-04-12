//
//  PrefsViewController.m
//  DMMacEggTimer
//
//  Created by lbq on 2018/4/12.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "PrefsViewController.h"

@interface PrefsViewController ()
@property (weak) IBOutlet NSPopUpButton *presetsPopup;
@property (weak) IBOutlet NSSlider *customSlider;
@property (weak) IBOutlet NSTextField *customTextField;

@end

@implementation PrefsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
- (IBAction)popupValueChanged:(id)sender {
}

- (IBAction)sliderValueChanged:(id)sender {
}
- (IBAction)cancelButtonClicked:(id)sender {
}
- (IBAction)okButtonClicked:(id)sender {
}

@end
