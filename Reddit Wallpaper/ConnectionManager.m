
//
//  ConnectionManager.m
//  Reddit Wallpaper
//
//  Created by Jeremy Curcio on 8/29/16.
//  Copyright © 2016 Jeremy Curcio. All rights reserved.
//

#import "ConnectionManager.h"

@implementation ConnectionManager

- (id)init {
    if (self = [super init]) {
        self.manager = [AFHTTPSessionManager manager];
        _session = [NSURLSession sharedSession];
    }
    
    return self;
}

- (void)downloadImageFromURL:(NSURL *)url saveToPath:(NSURL *)localPath completionHandler:(void (^)(NSURL *filePath, NSError *error))result {
    
    NSURLSessionDownloadTask *dataTask = [_session downloadTaskWithURL:url completionHandler:^(NSURL *location,NSURLResponse *response, NSError *error) {
       
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:localPath error:&error];
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                result(localPath, nil);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                result(nil, nil);
            });

        }
    }];
    
    [dataTask resume];
    
}

- (void)getTopPostsForSubreddit:(NSString *)subReddit completionHandler:(void (^)(NSMutableArray *posts, NSError *error))result {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/r/%@/top/.json?limit=20",subReddit]];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        if (error) {
            NSLog(@"%@",error);
        }
        NSLog(@"POSTS FOR %@",subReddit);
        
        NSMutableArray *imageURLs = [[NSMutableArray alloc] init];
        for (NSDictionary *post in [[json objectForKey:@"data"] objectForKey:@"children"]) {
            
            NSDictionary *d = [post objectForKey:@"data"];
            NSDictionary *preview = [d objectForKey:@"preview"];
            NSArray *imageArray = [preview objectForKey:@"images"];
            NSDictionary *images = [imageArray objectAtIndex:0];
            NSDictionary *source = [images objectForKey:@"source"];
            NSString *imageURL = [source objectForKey:@"url"];
            
            if (imageURL) {
                [imageURLs addObject:imageURL];
            }
        }
        
        result(imageURLs, error);
        
    }];
    
    [dataTask resume];

}

- (NSURL *)getLocalURLForImage:(NSString *)imageURL {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *dirPath = nil;
    
    // Find the application support directory in the home directory.
    NSArray* appSupportDir = [fm URLsForDirectory:NSApplicationSupportDirectory
                                        inDomains:NSUserDomainMask];
    if ([appSupportDir count] > 0)
    {
        dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:bundleID];
        
        NSError *theError = nil;
        if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES attributes:nil error:&theError]) {
            return nil;
        }
    }
    
    dirPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dirPath,imageURL]];
    return dirPath;
}

- (NSURL *)getLocalURLForSubList {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *dirPath = nil;
    
    // Find the application support directory in the home directory.
    NSArray* appSupportDir = [fm URLsForDirectory:NSApplicationSupportDirectory
                                        inDomains:NSUserDomainMask];
    if ([appSupportDir count] > 0)
    {
        dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:bundleID];
        
        NSError *theError = nil;
        if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES attributes:nil error:&theError]) {
            return nil;
        }
    }
    
    dirPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@sublist",dirPath]];
    return dirPath;
}

@end
