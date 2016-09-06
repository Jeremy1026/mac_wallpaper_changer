//
//  ViewController.m
//  Reddit Wallpaper
//
//  Created by Jeremy Curcio on 8/29/16.
//  Copyright © 2016 Jeremy Curcio. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _cm = [[ConnectionManager alloc] init];
    _posts = [[NSMutableArray alloc] init];
    _subPath = [_cm getLocalURLForSubList];

    NSArray *subList = [[NSArray alloc] initWithContentsOfURL:_subPath];
    _subredditArrayController = [[NSArrayController alloc] initWithContent:subList];

    [[_subredditField window] makeFirstResponder:_subredditField];

    [self prepareTable];

}

- (void)viewWillAppear {
    [super viewWillAppear];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *seconds = [defaults objectForKey:@"refreshTimer"];
    NSLog(@"seconds: %@",seconds);
    if ([seconds intValue] == 60) {
        [_timePrefSelector selectItemWithTag:1];
    }
    else if ([seconds intValue] == 60*5) {
        [_timePrefSelector selectItemWithTag:2];
    }
    else if ([seconds intValue] == 60*30) {
        [_timePrefSelector selectItemWithTag:3];
    }
    else if ([seconds intValue] == 60*60) {
        [_timePrefSelector selectItemWithTag:4];
    }
    else if ([seconds intValue] == 60*60*24) {
        [_timePrefSelector selectItemWithTag:5];
    }
}

- (void)prepareTable {
    NSTableColumn *subreddits = [_subredditTableView tableColumnWithIdentifier:@"subreddits"];
    [subreddits bind:@"value" toObject:_subredditArrayController withKeyPath:@"arrangedObjects.sub" options:nil];
    
    NSDictionary *doubleClickOptionsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"inspect:", @"NSSelectorName",
                                            [NSNumber numberWithBool:YES], @"NSConditionallySetsHidden",
                                            [NSNumber numberWithBool:YES], @"NSRaisesForNotApplicableKeys",
                                            nil];
    [_subredditTableView bind:@"doubleClickArgument" toObject:_subredditArrayController withKeyPath:@"selectedObjects" options:doubleClickOptionsDict];
    [_subredditTableView bind:@"doubleClickTarget" toObject:self withKeyPath:@"self" options:doubleClickOptionsDict];
}

- (void)setWallpaperFromPosts:(NSArray *)posts {
    if (!_cm) {
        _cm = [[ConnectionManager alloc] init];
    }
    NSInteger index;
    if (posts.count > 1) {
        index = arc4random() % (NSUInteger)(posts.count - 1);
    }
    else {
        index = 0;
    }
    NSURL *url = [NSURL URLWithString:posts[index]];
    
    NSString *localPath = [_cm getLocalURLForImage:[[posts[index] lastPathComponent] stringByDeletingPathExtension]].path;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:localPath];
    NSLog(@"Local Path: %@",localPath);
    NSLog(@"File Exists? %@",fileExists ? @"YES" : @"NO");
    if (fileExists) {
        url = [_cm getLocalURLForImage:[[posts[index] lastPathComponent] stringByDeletingPathExtension]];
        NSError *error;
        for (NSScreen *screen in  [NSScreen screens]) {
            [[NSWorkspace sharedWorkspace] setDesktopImageURL:url forScreen:screen options:[NSDictionary dictionary] error:&error];
//            NSLog(@"error: %@",error);
        }
        
    }
    else {
        NSURL *path = [_cm getLocalURLForImage:[[posts[index] lastPathComponent] stringByDeletingPathExtension]];
        [_cm downloadImageFromURL:url saveToPath:path completionHandler:^(NSURL *path, NSError *error) {
            if (path) {
                for (NSScreen *screen in  [NSScreen screens]) {
                    [[NSWorkspace sharedWorkspace] setDesktopImageURL:path forScreen:screen options:[NSDictionary dictionary] error:&error];
//                    NSLog(@"error: %@",error);
                }
            }
            else {
                [self setWallpaperFromPosts:posts];
            }
        }];
    }

}

- (IBAction)updateRefreshTime:(id)sender {
    NSMenuItem *item = (NSMenuItem *)sender;
    int seconds;
    switch (item.tag) {
        case 1:
//            seconds = 10;
            seconds = 60;
            break;
        case 2:
            seconds = 60 * 5;
            break;
        case 3:
            seconds = 60 * 30;
            break;
        case 4:
            seconds = 60 * 60;
            break;
        case 5:
            seconds = 60 * 60 * 24;
            break;
        default:
            break;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:seconds] forKey:@"refreshTimer"];
    [defaults synchronize];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timePrefChanged" object:self];

    NSLog(@"sender tag: %li",(long)item.tag);
}

- (IBAction)newWallpaper:(id)sender {
    [self setWallpaperFromPosts:_posts];
}

- (IBAction)addSubreddit:(id)sender {
    NSDictionary *dict = @{@"sub": _subredditField.stringValue};
    [_subredditArrayController addObject: dict];
    [_subredditArrayController.arrangedObjects writeToURL:_subPath atomically:YES];
    _subredditField.stringValue = @"";

//    [self getImageURLs];

}

- (void)inspect:(NSArray *)selectedObjects
{
    // handle user double-click
    NSLog(@"Double click on %@",selectedObjects);
    [_subredditArrayController removeObjects:selectedObjects];
    [_subredditArrayController.arrangedObjects writeToURL:_subPath atomically:YES];

//    [self getImageURLs];

    // this is an example of inspecting each selected object in the selection
 }



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
