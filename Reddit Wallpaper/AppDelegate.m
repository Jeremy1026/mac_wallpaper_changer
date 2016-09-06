//
//  AppDelegate.m
//  Reddit Wallpaper
//
//  Created by Jeremy Curcio on 8/29/16.
//  Copyright © 2016 Jeremy Curcio. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _cm = [[ConnectionManager alloc] init];
    _posts = [[NSMutableArray alloc] init];
    _subPath = [_cm getLocalURLForSubList];
    
    [self scheduleNotification];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setTitle:@"RW"];
    [self.statusItem setHighlightMode:YES];

    NSArray *subList = [[NSArray alloc] initWithContentsOfURL:_subPath];
    _subredditArrayController = [[NSArrayController alloc] initWithContent:subList];
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    _vc = [storyboard instantiateControllerWithIdentifier:@"preferences"];
    
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scheduleNotification)
                                                 name:@"timePrefChanged"
                                               object:nil];
    [self getImageURLs];
}

- (void)scheduleNotification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *seconds = [defaults objectForKey:@"refreshTimer"];
    NSDate *sendDate = [[NSDate date] dateByAddingTimeInterval:[seconds doubleValue]];
    
    NSLog(@"DATE: %@",[NSDate date]);
    NSLog(@"SEND DATE: %@",sendDate);
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    _notification = [[NSUserNotification alloc] init];
    _notification.deliveryDate = sendDate;
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:_notification];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification {
    [self scheduleNotification];
    [self newWallpaper:nil];
    NSLog(@"Notifcation sent");
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)showPreferences:(id)sender {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *wc = [storyboard instantiateControllerWithIdentifier:@"windowController"];
    wc.contentViewController = _vc;
    [wc showWindow:self];

}

- (IBAction)newWallpaper:(id)sender {
    [_vc setWallpaperFromPosts:_posts];
    [self getImageURLs];
}

- (void)getImageURLs {
    
    [_posts removeAllObjects];
    for (NSDictionary *sub in _subredditArrayController.arrangedObjects) {
        [_cm getTopPostsForSubreddit:[sub objectForKey:@"sub"] completionHandler:^(NSMutableArray *posts, NSError *error) {
            for (NSString *url in posts) {
                [_posts addObject:url];
            }
            _vc.posts = posts;
        }];
    }
    
}

@end
