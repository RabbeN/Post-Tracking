//
//  OutsideItem.h
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutsideItem : NSObject

@property (nonatomic, strong) NSString *itemDate;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *department;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
