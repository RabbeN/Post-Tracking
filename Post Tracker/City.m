//
//  City.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "City.h"

@implementation City

+ (id)cityWithJSON:(NSDictionary *)json {
    return [[self alloc] initWithJSON:json];
}

- (id)initWithJSON:(NSDictionary *)json {
    self = [super init];
    
    if (self) {
        _cityID = [[json objectForKey:@"ID_city"] intValue];
        _rusName = [json objectForKey:@"rus_name"];
        _latName = [json objectForKey:@"lat_name"];
    }
    return self;
}

- (NSComparisonResult)compare:(City *)compare {
    return [self.rusName compare:compare.rusName];
}

@end
