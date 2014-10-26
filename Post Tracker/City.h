//
//  City.h
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (assign) int cityID;
@property (nonatomic, strong) NSString *rusName;
@property (nonatomic, strong) NSString *latName;

+ (id)cityWithJSON:(NSDictionary *)json;
- (id)initWithJSON:(NSDictionary *)json;
- (NSComparisonResult)compare:(City *)compare;

@end
