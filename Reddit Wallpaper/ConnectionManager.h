//
//  ConnectionManager.h
//  Reddit Wallpaper
//
//  Created by Jeremy Curcio on 8/29/16.
//  Copyright © 2016 Jeremy Curcio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ConnectionManager : NSObject <NSURLSessionDelegate>

@property (strong) AFHTTPSessionManager *manager;
@property (strong) NSURLSession *session;

- (void)downloadImageFromURL:(NSURL *)url saveToPath:(NSURL *)localPath completionHandler:(void (^)(NSURL *filePath, NSError *error))result;
- (void)getTopPostsForSubreddit:(NSString *)subReddit completionHandler:(void (^)(NSMutableArray *posts, NSError *error))result;

- (NSURL *)getLocalURLForImage:(NSString *)imageURL;
- (NSURL *)getLocalURLForSubList;

@end
