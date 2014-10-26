//
//  TrackNumber.h
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackNumber : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *insideData;
@property (nonatomic, strong) NSMutableArray *outsideData;

- (id)initWithName:(NSString *)name andDictionary:(NSDictionary *)dictionary;

@end
