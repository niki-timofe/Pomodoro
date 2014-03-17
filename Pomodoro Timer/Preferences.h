//
//  Preferences.h
//  Pomodoro Timer
//
//  Created by Тимофеев Никита on 16.03.14.
//  Copyright (c) 2014 Тимофеев Никита. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Preferences : NSWindowController
- (IBAction)prefChange:(NSTextField *)sender;

@property (weak) IBOutlet NSTextField *pomoField;
@property (weak) IBOutlet NSTextField *breakField;
@property (weak) IBOutlet NSTextField *longBreakField;

@end
