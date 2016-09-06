//
//  ViewController.h
//  Reddit Wallpaper
//
//  Created by Jeremy Curcio on 8/29/16.
//  Copyright © 2016 Jeremy Curcio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ConnectionManager.h"

@class ConnectionManager;

@interface ViewController : NSViewController <NSTabViewDelegate>

@property (strong) NSMutableArray *posts;
@property (strong) NSArrayController *subredditArrayController;
@property (strong) ConnectionManager *cm;
@property (weak) IBOutlet NSTableView *subredditTableView;
@property (weak) IBOutlet NSTextField *subredditField;
@property (strong) NSURL *subPath;
@property (weak) IBOutlet NSPopUpButton *timePrefSelector;


- (void)setWallpaperFromPosts:(NSArray *)posts;
//- (void)getImageURLs;

- (IBAction)updateRefreshTime:(id)sender;
- (IBAction)newWallpaper:(id)sender;
- (IBAction)addSubreddit:(id)sender;

- (void)prepareTable;
- (void)inspect:(NSArray *)selectedObjects;     // user double-clicked an item in the table

@end

