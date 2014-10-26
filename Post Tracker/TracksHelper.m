//
//  TracksHelper.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "TracksHelper.h"
#import "TrackNumber.h"
#import "InsideItem.h"
#import "OutsideItem.h"

@implementation TracksHelper

- (id)init {
    self = [super init];
    
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    static TracksHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
    });
    
    return _sharedInstance;
}

- (void)addTrackNumber:(NSString *)track withName:(NSString *)name {
    NSArray *tracks = [self.userDefaults arrayForKey:@"tracks"];
    
    NSDictionary *trackDict = [NSDictionary dictionaryWithObjects:@[name, track] forKeys:@[@"name", @"track"]];
    
    NSMutableArray *mTracks = tracks ? [tracks mutableCopy] : [NSMutableArray array];
    [mTracks addObject:trackDict];
    
    [self.userDefaults setObject:mTracks forKey:@"tracks"];

    [self.userDefaults synchronize];
}

- (BOOL)checkNewTrackName:(NSString *)name {
    BOOL found = NO;
    NSArray *tracks = [self.userDefaults arrayForKey:@"tracks"];
    for (NSDictionary *track in tracks) {
        NSString *objectName = [track objectForKey:@"name"];
        if ([objectName isEqualToString:name]) {
            found = YES;
            break;
        }
    }
    return !found;
}

- (BOOL)checkNewTrack:(NSString *)track {
    BOOL found = NO;
    NSArray *tracks = [self.userDefaults arrayForKey:@"tracks"];
    for (NSDictionary *trackDict in tracks) {
        NSString *objectTrack = [trackDict objectForKey:@"track"];
        if ([objectTrack isEqualToString:track]) {
            found = YES;
            break;
        }
    }
    return !found;
}

- (NSArray *)getTrackList {
    NSArray *tracks = [self.userDefaults objectForKey:@"tracks"];
    if (!tracks || [tracks count] == 0) {
        return @[];
    } else {
        return tracks;
    }
}

- (void)removeTrackNumber:(NSString *)track {
    NSArray *tracks = [self.userDefaults objectForKey:@"tracks"];
    NSMutableArray *mutTracks = [tracks mutableCopy];
    
    for (NSDictionary *trackDict in tracks) {
        if ([[trackDict objectForKey:@"track"] isEqualToString:track]) {
            [mutTracks removeObject:trackDict];
            break;
        }
    }
    
    [self.userDefaults setObject:mutTracks forKey:@"tracks"];
    [self.userDefaults synchronize];
}

- (void)loadDataWithCompletion:(void(^)())completion forTrack:(TrackNumber *)track {
    NSString *name = track.name;
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://belpost.dev6.j-lab.biz/gettrack.php?t=%@", name]];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            // TODO
        } else {
            NSError *error;
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

            if (!error) {
                NSArray *insideJSONArray = [responseObject valueForKey:@"inside"];
                NSArray *outsideJSONArray = [responseObject valueForKey:@"outside"];
                
                NSMutableArray *insideArray = [NSMutableArray new];
                NSMutableArray *outsideArray = [NSMutableArray new];
                
                for (NSDictionary *insideJSONDictionary in insideJSONArray) {
                    [insideArray addObject:[[InsideItem alloc] initWithDictionary:insideJSONDictionary]];
                }
                
                for (NSDictionary *outsideJSONDictionary in outsideJSONArray) {
                    [outsideArray addObject:[[InsideItem alloc] initWithDictionary:outsideJSONDictionary]];
                }
                
                track.insideData = insideArray;
                track.outsideData = outsideArray;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion();
                    }
                });
                
            }
        }
    }];
}
@end
