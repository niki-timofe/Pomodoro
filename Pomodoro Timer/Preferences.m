//
//  Preferences.m
//  Pomodoro Timer
//
//  Created by Тимофеев Никита on 16.03.14.
//  Copyright (c) 2014 Тимофеев Никита. All rights reserved.
//

#import "Preferences.h"

NSUserDefaults *userDefaults;

@interface Preferences ()

@end

@implementation Preferences

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    userDefaults = [NSUserDefaults standardUserDefaults];
    [[self pomoField] setIntValue:(int)[userDefaults integerForKey:@"Pomodoro"]];
    [[self breakField] setIntValue:(int)[userDefaults integerForKey:@"Break"]];
    [[self longBreakField] setIntValue:(int)[userDefaults integerForKey:@"Long Break"]];
}

- (IBAction)prefChange:(NSTextField *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([sender integerValue] > 0) {
        if ([sender tag] == 0) {
            [userDefaults setInteger:[sender integerValue]  forKey:@"Pomodoro"];
        } else if ([sender tag] == 1) {
            [userDefaults setInteger:[sender integerValue]  forKey:@"Break"];
        } else if ([sender tag] == 2) {
            [userDefaults setInteger:[sender integerValue]  forKey:@"Long Break"];
        }
    }
}
@end
