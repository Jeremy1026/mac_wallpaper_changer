//
//  AppDelegate.h
//  Reddit Wallpaper
//
//  Created by Jeremy Curcio on 8/29/16.
//  Copyright © 2016 Jeremy Curcio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ConnectionManager.h"
#import "ViewController.h"

@class ConnectionManager;
@class ViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property (strong) ConnectionManager *cm;
@property (strong) ViewController *vc;

@property (strong) NSUserNotification *notification;

@property (weak) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusItem;

@property (strong) NSMutableArray *posts;
@property (strong) NSArrayController *subredditArrayController;
@property (strong) NSURL *subPath;

- (void)scheduleNotification;

- (IBAction)showPreferences:(id)sender;

- (IBAction)newWallpaper:(id)sender;
- (void)getImageURLs;

@end

