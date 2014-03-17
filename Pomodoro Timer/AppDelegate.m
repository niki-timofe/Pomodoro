//
//  AppDelegate.m
//  Pomodoro Timer
//
//  Created by Тимофеев Никита on 15.03.14.
//  Copyright (c) 2014 Тимофеев Никита. All rights reserved.
//

#import "AppDelegate.h"
#import "Preferences.h"

NSDate *scheduleTime;
NSUserNotification *notification;
NSUserDefaults *userDefaults;
NSInteger tomatoTimes[3];

@implementation AppDelegate

@synthesize statusBar = _statusBar;
@synthesize pomoTimer;

- (IBAction)startTimer {
    _menuItem.title = @"Stop";
    self.pomoTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(tick) userInfo:nil repeats:YES];
    NSRunLoop * rl = [NSRunLoop mainRunLoop];
    [rl addTimer:pomoTimer forMode:NSRunLoopCommonModes];
    scheduleTime = [NSDate dateWithTimeIntervalSinceNow:[self getTimeForTomato:currentTomato] * 60];
    
    for (NSUserNotification *notif in [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications]) {
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:notif];
    }
    
    notification = [[NSUserNotification alloc] init];
    [notification setTitle:@"Pomodoro is over"];
    [notification setHasActionButton: YES];
    
    NSString *pomoText;
    if (currentTomato == POMODORO) {
        if (tomatosElapsed == 4) {
            pomoText = @"It's time to take a LONG break";
        } else {
            pomoText = @"It's time to take a break";
        }
        [notification setActionButtonTitle: @"Take a break"];
        self.statusBar.image = [NSImage imageNamed:@"status-pomodoro.tiff"];
    } else if (currentTomato == BREAK) {
        pomoText = @"It's time to work";
        [notification setActionButtonTitle: @"Go work"];
        self.statusBar.image = [NSImage imageNamed:@"status-short-break.tiff"];
    } else if (currentTomato == LONG_BREAK) {
        pomoText = @"It's time to work";
        [notification setActionButtonTitle: @"Go work"];
        self.statusBar.image = [NSImage imageNamed:@"status-long-break.tiff"];
    }
    
    [notification setInformativeText:pomoText];
    [notification setSoundName:NSUserNotificationDefaultSoundName];
}

- (IBAction)stopTimer {
    _menuItem.title = @"Run";
    if ([pomoTimer isValid]) {
        [pomoTimer invalidate];
    }
    self.statusBar.title = @"";
    self.statusBar.image = [NSImage imageNamed:@"status-idle.tiff"];
}

- (void)tick {
    NSInteger secondsLeft = [scheduleTime timeIntervalSinceNow];
    NSInteger mins = ceil(secondsLeft / 60);
    NSInteger secs = secondsLeft % 60;
    
    if (secs % 2 == 0) {
        self.statusBar.title = [NSString stringWithFormat:@" %02ld %02ld", mins, secs];
    } else if (secondsLeft == 0) {
        self.statusBar.title = [NSString stringWithFormat:@" %02ld:%02ld", mins, secs];
    } else {
        self.statusBar.title = [NSString stringWithFormat:@" %02ld:%02ld", mins, secs];
    }
    
    if (secondsLeft < 1) {
        NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
        [center setDelegate:self];
        [center deliverNotification:notification];
        [self stopTimer];
        
        if (currentTomato == POMODORO) {
            tomatosElapsed++;
            if (tomatosElapsed == 4) {
                [[self pomodoroItem] setState:0];
                [[self breakItem] setState:0];
                [[self longBreakItem] setState:1];
                currentTomato = LONG_BREAK;
                tomatosElapsed = 0;
            } else {
                [[self pomodoroItem] setState:0];
                [[self breakItem] setState:1];
                [[self longBreakItem] setState:0];
                currentTomato = BREAK;
            }
        } else if (currentTomato == LONG_BREAK) {
            [[self pomodoroItem] setState:1];
            [[self breakItem] setState:0];
            [[self longBreakItem] setState:0];
            currentTomato = POMODORO;
        } else if (currentTomato == BREAK) {
            [[self pomodoroItem] setState:1];
            [[self breakItem] setState:0];
            [[self longBreakItem] setState:0];
            currentTomato = POMODORO;
        }
        [[self pomodoroItem] setTitle:[NSString stringWithFormat:@"Pomodoro #%li", tomatosElapsed + 1]];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    if (![[userDefaults objectForKey:@"Pomodoro"] length]) {
        [userDefaults setInteger:25  forKey:@"Pomodoro"];
        [userDefaults setInteger:5  forKey:@"Break"];
        [userDefaults setInteger:15  forKey:@"Long Break"];
    }
    
    tomatoTimes[0] = [userDefaults integerForKey:@"Pomodoro"];
    tomatoTimes[1] = [userDefaults integerForKey:@"Break"];
    tomatoTimes[2] = [userDefaults integerForKey:@"Long Break"];
    
    currentTomato = POMODORO;
    tomatosElapsed = 0;
}

- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // you can also set an image
    self.statusBar.image = [NSImage imageNamed:@"status-idle.tiff"];
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
}

- (void) userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification
{
    if (![pomoTimer isValid]) {
        [self startTimer];        
    }
}

- (NSInteger) getTimeForTomato:(Tomato)tomato {
    tomatoTimes[0] = [userDefaults integerForKey:@"Pomodoro"];
    tomatoTimes[1] = [userDefaults integerForKey:@"Break"];
    tomatoTimes[2] = [userDefaults integerForKey:@"Long Break"];
    return tomatoTimes[tomato];
}

- (IBAction)changeState:(id)sender {
    if ([pomoTimer isValid]) {
        [self stopTimer];
        
    } else {
        [self startTimer];
    }
}

- (IBAction)changePomodoro:(NSMenuItem *)sender {
    @try {
        [self stopTimer];
    }
    @catch (id ex) {
        NSLog(@"%@", ex);
    }
    
    [[self pomodoroItem] setState:0];
    [[self breakItem] setState:0];
    [[self longBreakItem] setState:0];
    [sender setState:1];
    
    if ([sender tag] == 0) {
        currentTomato = POMODORO;
    } else if ([sender tag] == 1) {
        currentTomato = BREAK;
    } else if ([sender tag] == 2) {
        currentTomato = LONG_BREAK;
    }
}

- (IBAction)openPrefsPage:(id)sender {
    if (!prefsWindow) {
        prefsWindow = [[Preferences alloc] initWithWindowNibName:@"Preferences"];
    }
    [prefsWindow showWindow:self];
}
@end
