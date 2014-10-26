//
//  TracksHelper.h
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TrackNumber;

@interface TracksHelper : NSObject

@property (nonatomic, strong) NSUserDefaults *userDefaults;
//@property (nonatomic, strong) TrackNumber *trackNumber;

+ (instancetype)sharedInstance;
- (void)addTrackNumber:(NSString *)track withName:(NSString *)name;
- (BOOL)checkNewTrackName:(NSString *)name;
- (BOOL)checkNewTrack:(NSString *)track;
- (NSArray *)getTrackList;
- (void)removeTrackNumber:(NSString *)track;
- (void)loadDataWithCompletion:(void(^)())completion forTrack:(TrackNumber *)track;

@end
