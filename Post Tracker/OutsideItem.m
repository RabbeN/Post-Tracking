//
//  OutsideItem.m
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import "OutsideItem.h"

@implementation OutsideItem

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _itemDate = [dictionary objectForKey:@"date"];
        _desc = [dictionary objectForKey:@"description"];
        _department = [dictionary objectForKey:@"department"];
    }
    return self;
}

@end
