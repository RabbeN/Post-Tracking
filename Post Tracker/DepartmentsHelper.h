//
//  DepartmentsHelper.h
//  Post Tracker
//
//  Created by Dmitry Putintsev on 10/24/14.
//  Copyright (c) 2014 Dmitry Putintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface DepartmentsHelper : NSObject

@property (nonatomic, strong) City *currentCity;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *departments;

+ (instancetype)sharedInstance;
- (City *)cityWithId:(int)cityID;
- (City *)cityWithName:(NSString *)cityName;
- (NSString *)currentCityName;
- (NSArray *)departmentsWithCityID:(int)cityID;
- (NSArray *)departmentsWithCurrentCity;

@end
