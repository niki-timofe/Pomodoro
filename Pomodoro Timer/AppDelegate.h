//
//  AppDelegate.h
//  Pomodoro Timer
//
//  Created by Тимофеев Никита on 15.03.14.
//  Copyright (c) 2014 Тимофеев Никита. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSDictionary const *tomatoMessages;

@class Preferences;

typedef enum tomatoTypes {
    POMODORO,
    BREAK,
    LONG_BREAK
} Tomato;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>
{
    NSTimer *pomoTimer;
    NSInteger secLeft;
    NSInteger tomatosElapsed;
    Tomato currentTomato;
    
    Preferences *prefsWindow;
}

@property (strong) IBOutlet NSStatusItem *statusBar;
@property (weak) IBOutlet NSMenu *statusMenu;

@property (weak) IBOutlet NSMenuItem *pomodoroItem;
@property (weak) IBOutlet NSMenuItem *breakItem;
@property (weak) IBOutlet NSMenuItem *longBreakItem;

@property (weak) IBOutlet NSMenuItem *menuItem;

@property (nonatomic, retain) NSTimer *pomoTimer;

- (IBAction)startTimer;
- (IBAction)stopTimer;

- (IBAction)changeState:(id)sender;
- (IBAction)changePomodoro:(NSMenuItem *)sender;
- (IBAction)openPrefsPage:(id)sender;

- (NSInteger)getTimeForTomato:(Tomato)tomato;

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification;
@end
